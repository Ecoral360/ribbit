// noinspection UnnecessaryLocalVariableJS
/*
uVM implementation in Javascript
Based-off the python implementation. Clumps are lists.
 */
const fs = require('fs')
const os = require('os')

const ENABLE_SCHEME_INTS = false

const TODO = () => {
    throw new Error("TODO!")
}

const _from_fixnum = ENABLE_SCHEME_INTS
    ? (x => {
        return x >> 1
    })
    : (x => x)

const _to_fixnum = ENABLE_SCHEME_INTS
    ? (x => {
        return (x << 1) | 1
    })
    : (x => {
        return x
    })


const CONST_OP = 0
const GET_OP = 1
const SET_OP = 2
const IF_OP = 3
const JUMP_OP = 4
const CALL_OP = 5

const TAG_PAIR = _to_fixnum(0)
const TAG_PROC = _to_fixnum(1)
const TAG_STR = _to_fixnum(2)
const TAG_SYM = _to_fixnum(3)
const TAG_TRUE = _to_fixnum(4)
const TAG_FALSE = _to_fixnum(5)
const TAG_NUL = _to_fixnum(6)
const TAG_CODE = _to_fixnum(7)

const NIL = _to_fixnum(0)

const CAR_I = 0
const CDR_I = 1
const TAG_I = 2
const NEXT_PC_I = 2

const NULL = [0, 0, TAG_NUL]
const TRUE = [0, 0, TAG_TRUE]
const FALSE = [0, 0, TAG_FALSE]

/** Variables for the VM **/
let stack = NIL
let st = NIL
let pc = NIL

function _obj_to_str(obj) {
    if (typeof (obj) === 'object') {
        return "CLMP"
    } else if (typeof (obj) === 'number') {
        return _from_fixnum(obj).toString()
    } else {
        return "err"
    }
}

function _parse_sexp(bytecode) {
    let scan = 1;
    let stack = []
    let word = ""
    let elements = []

    const push_word = () => {
        if (word.length !== 0) {
            elements.push(word)
            word = ""
        }
    }

    while (scan < bytecode.length - 1) {
        const c = bytecode[scan];

        if (c === '(') {
            stack.push(elements)
            elements = []
            scan++
        } else if (c === ')') {
            push_word()

            let complete = elements;
            elements = stack.pop()
            elements.push(complete)
            word = ""
            scan++
        } else if (c === ' ') {
            push_word()
            scan++
        } else {
            word += c
            scan++
        }
    }

    push_word()

    return elements
}

function _dump_stack() {
    let scout = stack

    while (NIL !== scout) {
        console.log('(' + scout.map(_obj_to_str).join(",") + ')');
        scout = scout[CDR_I]
    }
}

function _dump_symbol_table() {
    let scout = st

    while (scout !== NULL) {
        const sym = scout[CAR_I]
        const name = _read_vm_str(sym[CAR_I])
        const proc_or_pair = sym[CDR_I]

        let title;
        if (proc_or_pair[TAG_I] === TAG_PROC) {
            // TODO: check if int or clump
            title = "PRIM(" + _from_fixnum(proc_or_pair[CAR_I]) + ")"
        } else {
            title = "UNALLOC"
        }

        console.log(name + ":" + title)
        scout = scout[CDR_I]
    }
}

function _env() {
    let slow = null
    let scout = stack

    while (scout[TAG_I] !== TAG_PROC) {
        slow = scout
        scout = scout[CDR_I]
    }

    return slow
}

/**
 *
 * @param call_n_jump
 * @param proc_clump
 * @returns {boolean} whether the program counter should be moved forward
 * @private
 */
function _call_or_jump(call_n_jump, proc_clump) {
    const [, , val_tag] = proc_clump

    const is_primitive = (val_tag === TAG_PAIR)

    if (call_n_jump) {
        if (is_primitive) {
            const sym_no = proc_clump[CAR_I]
            let prim = PRIMITIVES[sym_no]
            prim()
        } else {
            const [args, , code_ptr] = proc_clump[CAR_I]

            const old_stack = stack
            const last_arg = _skip(args - 1)

            let env;

            if (args > 0) {
                env = last_arg[CDR_I]
            } else {
                env = old_stack
            }

            push_clump()
            stack = [env, proc_clump, pc]

            if (args > 0) {
                // Relink the arguments
                last_arg[CDR_I] = stack
                // Properly set the stack
                stack = old_stack
            }

            pc = code_ptr
        }
    } else {
        const [curr_env, , curr_ra] = _env()
        if (is_primitive) {
            const sym_no = proc_clump[CAR_I]
            let prim = PRIMITIVES[sym_no]
            prim()

            stack[CDR_I] = curr_env
            pc = curr_ra
        } else {
            const [args, , code_ptr] = proc_clump[CAR_I]

            const old_stack = stack
            const last_arg = _skip(args - 1)


            push_clump()
            stack = [curr_env, proc_clump, curr_ra]

            if (args > 0) {
                // Relink the last argument
                last_arg[CDR_I] = stack
                // Reset the env
                stack = old_stack
            }

            pc = code_ptr
        }
    }

    return is_primitive
}

function _alloc_str(str) {
    return str.split("").reverse().reduce((old, chr) => {
        return [chr.charCodeAt(0), old, TAG_STR]
    }, NULL);
}

function _read_vm_str(vm_str) {
    let str = ""

    while (NULL !== vm_str) {
        str += String.fromCharCode(vm_str[CAR_I])
        vm_str = vm_str[CDR_I]
    }

    return str
}

function _field(x) {
    let field = stack[CAR_I][x]
    push_clump()
    stack[CAR_I] = field
}

function _field_set(x) {
    let val = stack[CAR_I]
    pop_clump()
    stack[CAR_I][x] = val
}

function _argX(x) {
    // noinspection UnnecessaryLocalVariableJS
    const arg = _pop(2).reverse()[x]
    stack[CAR_I] = arg
}

function _skip(n) {
    let scout = stack

    while (--n >= 0) {
        scout = scout[CDR_I]
    }

    return scout
}

/**
 * Pop n-1 clump out of the stack and return the
 * first 'n' 'car'
 * @param n number of 'car' to get,
 * @returns {*[]}
 */
function _pop(n) {
    if (n < 1) {
        throw new Error("Cannot pop less than a single element")
    }

    let result = []

    while (n !== 1) {
        result.push(stack[CAR_I])
        pop_clump()
        n--
    }

    result.push(stack[CAR_I])

    return result
}


function _binop(op) {
    const [y, x] = _pop(2);
    const args = [x, y];
    const rValued = args.map(_from_fixnum);
    const result = rValued.reduce(op);

    stack[CAR_I] = _to_fixnum(result);
}

function push_clump(x = NIL) {
    stack = [x, stack, TAG_PAIR]
}

/**
 * Pop the clump on the TOS
 * @returns {*} the car of the clump
 */
function pop_clump() {
    const value = stack[CAR_I]
    stack = stack[CDR_I]
    return value
}


const id = () => {
}
const field0 = () => _field(0)
const field1 = () => _field(1)
const field2 = () => _field(2)
const field0_set = () => _field_set(0)
const field1_set = () => _field_set(1)
const field2_set = () => _field_set(2)
const lt = () => _binop((x, y) => x < y ? TRUE : FALSE)
const eq = () => _binop((x, y) => x === y ? TRUE : FALSE)
const add = () => _binop((x, y) => x + y)
const sub = () => _binop((x, y) => x - y)
const mul = () => _binop((x, y) => x * y)
const div = () => _binop((x, y) => x / y)
const arg1 = () => _argX(0)
const arg2 = () => _argX(1)

const putchar = () => {
    const output = String.fromCharCode(_from_fixnum(stack[CAR_I]))
    process.stdout.write(output)
}

let fixed_ipt = "(+ 2 2)\n"

const getchar = () => {
    let ipt = fixed_ipt[0]
    fixed_ipt = fixed_ipt.slice(1)
    // let ipt = null;
    //
    // while (!ipt) {
    //     ipt = process.stdin.read(1);
    // }
    //
    if (!ipt) {
        ipt = "";
    } else {
        process.stdout.write(ipt)
    }

    const val = _to_fixnum(ipt.charCodeAt(0))
    push_clump(val)
}
const close = () => {
    stack[TAG_I] = TAG_PROC
}

function cons() {
    const [cdr, car] = _pop(2)
    stack[CAR_I] = [car, cdr, 0]
}

function is_clump() {
    const is_it = typeof (stack[CAR_I]) === 'object'
    stack[CAR_I] = (is_it ? TRUE : FALSE)
}

const PRIMITIVES = [
    id,
    arg1,
    arg2,
    close,
    cons,
    is_clump,
    field0,
    field1,
    field2,
    field0_set,
    field1_set,
    field2_set,
    eq,
    lt,
    add,
    sub,
    mul,
    div,
    getchar,
    putchar
]

function build_sym_table(code) {
    const symbol_table = {}
    const lines = code.split(os.EOL)
    const marker = "symbol-table: ";

    function parse_symbol_array(array_line) {
        const symbols_array = JSON.parse(array_line.substr(marker.length))
        const nb_symbols = symbols_array.length;

        let next = NULL;
        for (let j = nb_symbols - 1; j > -1; j--) {
            const name = symbols_array[j];
            let proc;

            proc = [j, 0, TAG_PAIR]
            const symbol = [_alloc_str(name), proc, TAG_SYM]
            const entry = [symbol, next, TAG_PAIR]

            next = entry
        }

        // affect the global symbol table variable
        st = next
    }

    lines.every(line => {
        if (line.startsWith(marker)) {
            parse_symbol_array(line);
            return false
        }
        return true;
    });

    return symbol_table
}

function _find_sym(x) {
    let scout = st

    for (let i = 0; i < x; ++i) {
        scout = scout[CDR_I]
    }

    return scout[CAR_I]
}

function find_last_jump(pc) {
    let jump_c = 1;

    do {
        pc = pc[TAG_I]
        const instr = pc[CAR_I]
        const op = instr[0]

        if (op === "jump") {
            jump_c--
        } else if (op === "if") {
            jump_c++
        } else if (op === "const-proc") {
            jump_c--
        }
    } while (jump_c > 0);

    return pc;
}

function exec_if() {
    const truth = (pop_clump() !== FALSE)

    if (!truth) {
        // search the jump that ends the true branch
        pc = find_last_jump(pc)
    } // else : pc = pc + 1
}

/**
 * Exec the instruction at the current PC
 * Where the instruction is written in emulation mode,
 * ie the operation is described in a sexp
 */
function exec_emulation() {
    const instr = pc[CAR_I]
    const op = instr[0]
    const args = instr[1]

    // console.log("Executing " + instr)
    // console.log()
    // console.log()

    function call_or_jump(call_n_jump) {
        const go_to_what = args[0]

        if (go_to_what !== "sym") {
            throw new Error(`Don't know how to call a: ${go_to_what}`)
        }

        const which_symbol = parseInt(args[1])
        const sym = _find_sym(which_symbol)

        const name = _read_vm_str(sym[CAR_I])
        // console.log(`${call_n_jump ? "Calling" : "Jumping to"} ${name}`)

        return _call_or_jump(call_n_jump, sym[CDR_I])
    }

    switch (op) {

        case "const-proc": {
            const arg_count = parseInt(args)
            const proc_val = [arg_count, TAG_PAIR, pc[NEXT_PC_I]]

            const proc = [proc_val, _env(), TAG_PROC]
            push_clump(proc)

            pc = find_last_jump(pc)

            break
        }

        case "if" : {
            exec_if()
            break
        }

        case "get": {
            const get_what = args[0]

            if (get_what === "sym") {
                const sym_no = parseInt(args[1])
                const sym = _find_sym(sym_no)
                const sym_val = sym[CDR_I]
                push_clump(sym_val)
            } else if (get_what === "int") {
                const depth = parseInt(args[1])
                const clump = _skip(depth)
                push_clump(clump[CAR_I])
            } else {
                TODO()
            }

            break
        }

        case "call": {
            return call_or_jump(true);
        }

        case "jump" : {
            return call_or_jump(false);
        }

        case "set" : {
            const set_what = args[0]

            if (set_what !== "sym") {
                throw new Error(`I dont know how to set a '${set_what}'`)
            }

            const sym_no = parseInt(args[1])
            const sym = _find_sym(sym_no)

            const sym_name = _read_vm_str(sym[CAR_I])

            console.log("SET " + sym_name)
            //
            sym[CDR_I] = pop_clump()
            break
        }

        case "const" : {
            const const_what = args[0]

            if (const_what === "sym") {
                const what_sym = parseInt(args[1])
                const sym = _find_sym(what_sym)
                push_clump(sym)
            } else if (const_what === "int") {
                const val = _to_fixnum(parseInt(args[1]))
                push_clump(val)
            } else {
                TODO()
            }

            break
        }

        default: {
            throw new Error("Unsupported operation: " + op)
        }
    }

    return true
}

function exec() {
    const instr = _from_fixnum(pc[CAR_I])
    const operand = pc[CDR_I]

    function call_or_jump(call_n_jump) {
        const op_tag = operand[TAG_I]

        if (op_tag !== TAG_SYM) {
            // TODO: resolve tag
            throw new Error(`Don't know how to call a: ${_from_fixnum(op_tag)}`)
        }

        const name = _read_vm_str(operand[CAR_I])
        const which_symbol = _from_fixnum(operand[CDR_I][CAR_I])
        const sym = _find_sym(which_symbol)

        return _call_or_jump(call_n_jump, sym[CDR_I])
    }

    switch (instr) {
        case CONST_OP: {
            // TODO: not OK
            push_clump(0)
            break
        }

        case GET_OP: {
            // TODO: not OK
            push_clump(_skip(0)[CAR_I])
            break
        }

        case SET_OP: {
            TODO()
            break
        }

        case IF_OP: {
            exec_if()
            break
        }

        case JUMP_OP: {
            return call_or_jump(false)
        }

        case CALL_OP: {
            return call_or_jump(true)
        }
    }

    return true
}

/**
 * Check if we are done running the code
 * @returns {boolean}
 */
function _eoc() {
    return NULL === pc || NIL === pc
}

function run() {
    while (!_eoc()) {
        const instr = pc[CAR_I]

        let advance
        if (typeof (instr) === "number") {
            advance = exec()
        } else {
            advance = exec_emulation()
        }

        if (advance && !_eoc()) {
            pc = pc[TAG_I]
        }
    }

    console.debug("Done running")
    console.debug("Stack looks like:")
    _dump_stack()
}

function build_pc_clumps(code) {
    // first line is the last executed instruction
    // so the instructions are reversed already
    const lines = code.split(os.EOL).slice(1).filter(line => !line.startsWith(";"))
    pc = lines
        .map(_parse_sexp)
        .reduce((acc, s_exp) => [s_exp, TAG_CODE, acc], NULL);
}

function init_stack() {
    stack = [NIL, [pc, NIL, TAG_PROC], NULL]
}

function vm(code) {
    process.stdin.setEncoding('utf8');
    build_sym_table(code)
    build_pc_clumps(code)
    init_stack()

    // const sym = _find_sym(5);
    // console.log("Found symbol " + _read_vm_str(sym[0]))
    // const clumps = parse_code(code)
    run()
}

const main = async () => {
    fs.readFile("./lib2.o", "utf-8", (err, data) => {
        if (err) {
            console.error("Failed to read the source file: " + err)
        } else {
            vm(data)
        }
    });
}

// noinspection JSIgnoredPromiseFromCall
main()