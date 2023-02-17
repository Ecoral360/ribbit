import kotlin.math.max
import kotlin.system.exitProcess

typealias Rib = ArrayList<Any>
typealias GenericRib = ArrayList<*>

const val MAX_BYTE = 92
const val MULTI_BYTE_THRESHOLD = MAX_BYTE / 2
const val BYTE_OFFSET = 35
const val BYTE_DEFAULT = '9'.code      // 57
const val STRING_SEP = ','.code        // 44
const val SYMBOL_TABLE_END = ';'.code  // 59

val SHORT_ENCODINGS = arrayOf(20, 30, 0, 10, 11, 4)

//

const val CODE =
    "R'rdadac,>,=>,qssa,oludom,htgnel-rotcev,?=<rahc,?qe,rahc-etirw,?regetni,?orez,etacnurt,xam,?=gnirts,!llif-rotcev,!tes-gnirts,gnirtsbus,regetni>-rahc,htgnel-gnirts,gniliec,tel,fer-rotcev,?=>gnirts,raaaac,?=>rahc,rddaac,dna,?=rahc,!tes,=,raddac,?<rahc,rotaremun,mcl,rotcev-ekam,enifed,!llif-gnirts,rahc>-regetni,?>rahc,qmem,rdaaac,adbmal,?naeloob,raaddc,?=<gnirts,?evitisop,gnirts-ekam,radaac,rotanimoned,!rdc-tes,raaadc,raadac,rddadc,ro,rorre,fi,nim,roolf,?evitagen,etouq,!tes-rotcev,cc/llac,ypoc-gnirts,dnuor,radddc,nigeb,radadc,=<,dnoc,rdaddc,rdaadc,rddddc,dneppa-gnirts,?ddo,tixe,?<gnirts,pam,vmem,?>gnirts,?erudecorp,tsil>-rotcev,tpxe,gnirts>-rebmun,esrever,?rotcev,!rac-tes,fer-gnirts,redniamer,cossa,rebmun>-gnirts,lave,rebmem,vssa,?neve,hcae-rof,dcg,lobmys>-gnirts,gnirts>-lobmys,raac,radc,raadc,raaac,rdddac,lper,?gnirts,rdadc,rdaac,fer-tsil,radac,raddc,rdddc,?tcejbo-foe,enilwen,rotcev>-tsil,dneppa,+,sba,?lobmys,?llun,yalpsid,etirw,htgnel,daer,rahc-keep,?lauqe,rddac,tneitouq,,gnirts>-tsil,tsil>-gnirts,ton,,,rddc,,,*,,rdac,,,,rac,?riap,rahc-daer,<,-,rdc,snoc,,?vqe,,,,,;9)!S,9Fl@YN@YF_@YGiU7@YG^{])9)@YN@YFZ6^8N~YO^YD@YT8vCvR3y]67#YU.^z!U.8THi&:HiU6ai&kkz!U6:kw'k!TJ'_*YTJaB_G^~F^{!T9'^8T9YKlbB`^'`~?_G_~F_|!TA8TG`^YT9ka_BaG`1YTAdBbAai\$G`^~F_|!U/#`kn8:^~i\$#`kn8:^~i\$#`kn8:^~i\$#`kn8:^~YT5Q^~?w)I^~?kJ^~YT5^z!U'#YU/a_l{!TG#a_k#k_k~?iU6_{!?1b1:VfBdbw)k~FBaG`^|!T<1V:h-w7k1Vf~?iU6fdAaaa^}(!TF*i&^z!TI*YTF`^{!TB*YTIb`^|!T7*YTBca_wS+|!1#b`n8T<fAi&AbwU4awU4`8TAAea_`~YI_B`1ci\$1cYT7APdxLABKcxOGKa1cABKbxO~?GKbwU5~FBa_~?xL^1ci\$1cN^1cNYTBYT7APgwS-wU4wU4YTFYTI`wU4wSN~FPbKa~FBa_~?wS-^1ci%1cN^1cNYT7i\$APdwSH^~FPbKa~FBa_~?wSH^8T<fPdK`G_`GK`~?wSN^8?cBa_~?xO^#YTGewT?#d~YHbYTHi&:ViU6PeYTJAAfi\$i\$akYE_nK`~?wS9^1:HgZ*ecHfYAdboKa_~?wS+^1YU'dYT9lbKbYAa_~N?wS?_8T<fAi&AbwU4awU4`8TAAea_`~YI_B`1ci\$1cYT7APdxLABKcxOGKa1cABKbxO~?GKbwU5~FBa_~?xL^1ci\$1cN^1cNYTBYT7APgwS-wU4wU4YTFYTI`wU4wSN~FPbKa~FBa_~?wS-^1ci%1cN^1cNYT7i\$APdwSH^~FPbKa~FBa_~?wSH^8T<fPdK`G_`GK`~?wSN^8?cBa_~?xO^#YTGewT?#d~YHbYTHi&:ViU6PeYTJAAfi\$i\$akYE_nK`~?wS9^1:HgZ*ecHfYAdboKa_~?wS+^1YU'dYT9lbKbYAa_~N^~^?wSF^#cKan~?wS'^G_~F_#bYT9k``m~YI_|!T85_@L^{!N5uy!T,i5!;'i\$8;aB_@L^8;aB_@L^@LvS#~N?vS#_8;aB_@L^8;aB_@L^@LvS#~N^~^?vE^8;aB_@LvS;@LvS#~?t^8;aB_@LvS9@LvS#~?v0^8;aB_@LvS5@LvS#~?u^8;aB_@L^~S`G^~F^{!TL'i\$'i\$8TLB^@YFG^~F^@LvC~F^z!G8GZ>^8T8vS7vF~ZA^8FZ@^@LvF~Z<^8;i\$T^~Z(^8GZ/^~YI^5vL@YTLB^@YFG^@LvK~F^8T8vLvK~YH^8T8vS;vF~?i%^8T8vS-vF~S^z!F8G^5vE@Ri%T^@LvE~Z(^z!TN8TN8T>~?u^'^~Dk^Ey!T>8T>@E'^8TN~?vR0^~D_vC'iU8~YO^YCy!T68T6A`^8T6Aa^8T6Aat~?vS;^8T6Aav0~?vS9^8T6Aau~?vS5^E~?vS#^9=_~?vE^'i&~YO^Ez!T=*YT=^@E'i&~NNDvD`*YT=^@E'i&~NN^~^?vL_*YT=^@E'i&~N^~^?vK^YCy!TM*YTM^YD'i&@E~?vL^YT>y!8'_88CCvRL_M`v3@E~i\$'_88CCvRL_M`v3@E~DvS.^~D_vS'88CCvR,_M`v3@E~i\$'_88CCvRL_M`v3@E~i\$'_88CCvRL_M`v3@E~DvS.^~D_vS'88CCvR,_M`v3@E~DvR<^~D_vR588CCvR%_M`v3@E~i\$'_88CCvRL_M`v3@E~i\$'_88CCvRL_M`v3@E~DvS.^~D_vS'88CCvR,_M`v3@E~i\$'_88CCvRL_M`v3@E~i\$'_88CCvRL_M`v3@E~DvS.^~D_vS'88CCvR,_M`v3@E~DvR<^~D_vR588CCvR%_M`v3@E~DvR/^~D_vR\$YCz!D90`'^~^^Z7^UAYT=^@E8>YT6i&@E~?vE^*Ai&YDwS'@E~?vJ^8MYD,Okk88k@E~?vP^YC@E~N?vRM_8MYD,Okk88k@E~?vP^YC@E~N^~^?vS?^'i%@E~?vS;^'i\$@E~?vS-^YC@E~?vF^8TM@E~?vK^'^~Dk^YT>y!C'^!U1^Ey!U&'^!U1iU3'^~?iU8^!U1^z!.8U&^8U&YU+~?iU3^'^~?iU8^iU1y!U1iU3!O(iU8^z!S%7%YT?'_@YU0Qc^@YTDJc^IIYT?i\$zIIYT?i\$z]2'i\$92B`^@X\$G_~F_{]D'i&*ZDBa_X\$G_~F_{!TH#l`^{]AYT:l!T&8TDYT;aI_^{!S@8MYT;k^z!S&8TOb`J^|!SM9%`J^{!T/i2]@i3!M#oYE_^z]<YT:o!S>8TDYT;aI_^{!S\$8>YLi&T^z]H8>YLT`T^{!TP8>a8TPAfZ:bb`a_Cl`~Da_}'!T\$8TPi&b`^|!U*'k'iU8~F_'l8U*BbB`'l~D`^'iU8~D__G`G^~F_~F^{!TK8U*T`T^{!SL8<ZE`^{!S68<ZB`^{]B-YTKa_k{]E-kYTK`^{!T'(kYTK`^{!S48>YT;vC^z!T%8TOb`J^|]:9%`J^{!SPi2!=i3!>#nYE_^z](YT:n!S=i'!T#i'!SJiT2!T.jM!S<iT3!SCi-!SGi(!U#'_'i\$'i\$8U#CCvR%`MbuB_~DvR/^~D_vR\$G^~F^{!U)8U#k^'i\$~YH^z]7'i\$,_k~^YU)^8U)B^~?vPG^'i\$~YH^T^z!TC'^8TC_`~DakAb^YKCMu``vR%Wu^{]>8>YTCi&^8>AYTCi&C`kvP~Dk^z]?'^6__~ZG`Z?Wm`M_^'l~?k_{!S#i'!T)i'!SOi'!S)i'!S2'lz!SBi'!SA6_WZ1``_YJ`YJ^'k~?k_{!T@8T@_Z9__'_~?k^{]18T@`^8T@__~D__YJ`YJ^{!T08Kb^'^~?DkbDk`'k~?k^CM`a_W`^{]9,MWb``^{!J'^,_k~Dk^z!S*'_'^~D`^{!T('^'_~D`^{]G8<Z3^z]3(MWm`m^z!S(-k^z!S5-_kz!T*(k^z!T28<D`^{]M8<D__{!T3-__{!SEi(!T+8<YT5^z@YU,ki#!U2Ii#!U\$'^!U2AiU2^YU-^8U\$Ia_'^~YB`I^J_~F_{]08U\$iU2^z]/i2!U-#m_i\$z!IYT:m!U('`8U(Aca`Cl^~D_k|!T;8U(i&`^{]8'i\$98Ba_'^~YBG__G_~F_{!T1j4]4'i\$94Ba_'^~?G__G_~F_{]5'i\$95B`^'_~YBG`^~F_{!S;jC]C'i\$9CB`^'_~?G`^~F_{!TE'^8TECl`B^~D`k{!TO9;aYTE`^|]%0YTE`^{!U%'_8U%AaG_B^~F^{]=8U%i&^z!L'_*YLaB_G^~F^{!E'k8KYEB_l~F^z!H(i&^z]I8PI^z]P8PJ^z]K9#I^z!S79#J^z!S.9'I^z]N9'J^z]J9,I^z!S09,J^z!SD8AJ^z!T49\$I^z!S/9\$J^z!SI9&I^z!S39&J^z!S:9+I^z!SK9+J^z!P89I^z]#89J^z]'9-I^z],9-J^z]\$4J^z]&9.I^z]+9.J^z]-2J^z].3J^z]*8AI^z!A4I^z!92I^z!43I^z!S1iU,];iTD!+i2!0i3!*#k`^{!/YT:k!B'i\$'i\$'i\$'i\$8BJaJ_~YBIaI_~YBQaQ_~YT5`'i\$~?pQ_~YT5_'^~^?`^{!T-i(!S88<_'^~^?i%^z!<(i\$^z!T:8T?'i\$(bQ^~YT5^zz!U7:nl:ki&vC!U3Cmk!U8Clk!':lkl!):lkm!7:lkn!T?:lko!T5:lkp!3:lkq!2:lkr!::lks!TD:lkt!U,:lku!U0:lkv.!(:lkv/!-:lkv0!K:lkv1!,:lkv2!6:lkv3!@:lkv4!U+:lkv5!5:lkv6]F:lkv7y"  // @@(replace __SOURCE__ source)@@

fun rib(x: Any, y: Any, z: Any): Rib = arrayListOf(x, y, z)

fun putChar(c: Any): Int {
    print((c as Int).toChar())
    // System.out.flush() // FIXME: may be useless
    return c
}

fun getChar() {
    val char = System.`in`.read()
    push(char)
}

fun push(x: Any) {
    stack = rib(x, stack, 0)
}

fun pop(): Any {
    val valuePopped = stack.asRib()[0]
    stack = stack.asRib()[1]  // set stack to the inner stack
    return valuePopped
}

// inline fun <reified T> popAs() = pop() as T

fun setGlobal(value: Any) {
    symbolTable.asRib()[0].asRib()[0] = value
    symbolTable = symbolTable.asRib()[1]
}

// @@(feature boolean
fun toBool(x: Boolean): Rib {
    return if (x) TRUE else FALSE
}
// )@@

fun getByte(): Int = CODE[pos++].code

fun getCode(): Int {
    val adjustedByte = getByte() - BYTE_OFFSET
    return if (adjustedByte < 0) BYTE_DEFAULT else adjustedByte
}

fun getInt(n: Int): Int {
    val code = getCode()
    val offset = n * MULTI_BYTE_THRESHOLD  // n represents the number of offsets x is getting
    return if (code < MULTI_BYTE_THRESHOLD) code + offset else getInt(code + offset - MULTI_BYTE_THRESHOLD)
}


fun prim1(f: (Any) -> Any): () -> Unit {
    return { push(f(pop())) }
}

fun prim2(f: (Any, Any) -> Any): () -> Unit {
    return { push(f(pop(), pop())) }
}

fun prim2Rib(f: (Any, Rib) -> Any): () -> Unit {
    return { push(f(pop(), pop().asRib())) }
}

fun prim3(f: (Any, Any, Any) -> Any): () -> Unit {
    return { push(f(pop(), pop(), pop())) }
}

fun arg2() {
    val x = pop()
    pop()
    push(x)
}

fun close() {
    push(rib(pop().asRib()[0], stack, 1))
}

fun fieldSet0(y: Any, x: Rib): Any {
    x[0] = y
    return y
}

fun fieldSet1(y: Any, x: Rib): Any {
    x[1] = y
    return y
}

fun fieldSet2(y: Any, x: Rib): Any {
    x[2] = y
    return y
}

/**
 * @return The next rib that doesn't end with a 0.
 */
fun getCont(): Rib {
    var s: Rib = stack.asRib()
    while (s[2] == 0) s = s[1].asRib()
    return s
}

fun getOpND(o: Any): Any =
    if (isRib(o)) {
        o.asRib()
    } else {
        listTail(stack.asRib(), o as Int)
    }


fun getSymbolFromRef(ref: Int): Any {
    return listTail(symbolTable.asRib(), ref).asRib()[0]
}

fun isRib(x: Any) = x is GenericRib

fun listTail(rib: Any, index: Int): Any =
    if (index == 0) {
        rib
    } else {
        listTail(rib.asRib()[1], index - 1)
    }

var PRIMITIVES = arrayOf(
    // @@(primitives (gen body ",")
    prim3 { z, y, x -> rib(x, y, z) },  // @@(primitive (rib z y x))@@
    prim1 { it },                       // @@(primitive (id x))@@
    ::pop,                              // @@(primitive (pop))@@
    ::arg2,                             // @@(primitive (arg2))@@
    ::close,                            // @@(primitive (close))@@
    prim1 { toBool(isRib(it)) },        // @@(primitive (rib? x))@@
    prim1 { it.asRib()[0] },            // @@(primitive (field-0 x))@@
    prim1 { it.asRib()[1] },            // @@(primitive (field-1 x))@@
    prim1 { it.asRib()[2] },            // @@(primitive (field-2 x))@@
    prim2Rib(::fieldSet0),              // @@(primitive (set-field-0 x))@@
    prim2Rib(::fieldSet1),              // @@(primitive (set-field-1 x))@@
    prim2Rib(::fieldSet2),              // @@(primitive (set-field-2 x))@@
    prim2 { y, x -> toBool(if (isRib(x) or isRib(y)) x === y else x == y) }, // @@(primitive (eqv? y x))@@
    prim2 { y, x -> toBool((x as Int) < y as Int) }, // @@(primitive (< x y))@@
    prim2 { y, x -> (x as Int) + y as Int }, // @@(primitive (+ x y))@@
    prim2 { y, x -> (x as Int) - y as Int }, // @@(primitive (- x y))@@
    prim2 { y, x -> (x as Int) * y as Int }, // @@(primitive (* x y))@@
    prim2 { y, x -> (x as Int) / y as Int }, // @@(primitive (/ x y))@@
    ::getChar,                            // @@(primitive (get-char))@@
    prim1(::putChar),                    // @@(primitive (put-char c))@@
    prim1 { exitProcess(it as Int) },      // @@(primitive (exit))@@
    // )@@
)

var pos = 0
val FALSE = rib(0, 0, 5)
val TRUE = rib(0, 0, 5)
val NIL = rib(0, 0, 5)


fun buildSymbolTable(): Rib {
    var symbolTable = NIL
    var n = getInt(0)
    while (n > 0) {
        n--
        symbolTable = rib(
            rib(FALSE, rib(NIL, 0, 3), 2), symbolTable, 0
        )
    }

    var chars = NIL
    var currentStringLen = 0
    var currentByte: Int = getByte()
    while (currentByte != SYMBOL_TABLE_END) {
        if (currentByte == STRING_SEP) {
            symbolTable = rib(rib(FALSE, rib(chars, currentStringLen, 3), 2), symbolTable, 0)
            chars = NIL
            currentStringLen = 0
        } else {
            chars = rib(currentByte, chars, 0)
            currentStringLen++
        }
        currentByte = getByte()
    }
    symbolTable = rib(rib(FALSE, rib(chars, currentStringLen, 3), 2), symbolTable, 0)
    return symbolTable
}


fun stackIsValid(): Boolean {
    return ((isRib(stack) && stack.asRib().isNotEmpty())
            || (stack is Int && stack != 0))
}

fun decodeRVM(): Rib {
    var n: Any
    while (true) {
        val code = getCode()
        n = code
        var d: Int
        var op = 0
        while (true) {
            d = SHORT_ENCODINGS[op]
            if (n <= (2 + d)) break
            n -= d + 3
            op++
        }
        if (code > 90) {
            n = pop()
        } else {
            if (op == 0) {
                stack = rib(0, stack, 0)
                op++
            }
            n = when {
                n == d -> getInt(0)
                n > d -> getSymbolFromRef(getInt(n - d - 1))
                op < 3 -> getSymbolFromRef(n)
                else -> n
            }
            if (op > 4) {
                n = rib(rib(n, 0, pop()), NIL, 1)
                if (!stackIsValid()) break
                op = 4
            }
        }
        stack.asRib()[0] = rib(op - 1, n, stack.asRib()[0])
    }
    return n.asRib()[0].asRib()[2].asRib()
}

var stack: Any = 0
var symbolTable: Any = buildSymbolTable()
var pc = decodeRVM()
fun main() {
    setGlobal(rib(0, symbolTable, 1))
    setGlobal(FALSE)
    setGlobal(TRUE)
    setGlobal(NIL)
    stack = rib(0, 0, rib(5, 0, 0))  // primordial continuation (executes the halt instruction)
    while (true) {
        var o = pc[1]
        when (pc[0] as Int) {
            0 -> { // jump/call
                o = getOpND(o).asRib()[0]
                var c = o.asRib()[0]
                if (isRib(c)) {  // non-primitive jump/call
                    val c2 = rib(0, o, 0)
                    var s2 = c2
                    var nargs = c.asRib()[0] as Int
                    while (nargs > 0) {
                        s2 = rib(pop(), s2, 0)
                        nargs--
                    }
                    if (isRib(pc[2])) { // call
                        c2[0] = stack
                        c2[2] = pc[2]
                    } else { // jump
                        val k = getCont()
                        c2[0] = k[0]
                        c2[2] = k[2]
                    }
                    stack = s2
                } else {  // primitive jump/call
                    PRIMITIVES[c as Int]()
                    if (isRib(pc[2])) {  // call
                        c = pc
                    } else {  // jump
                        c = getCont()
                        stack.asRib()[1] = c[0]
                    }
                }
                pc = c.asRib()[2].asRib()
            }

            1 -> {  // set
                getOpND(o).asRib()[0] = stack.asRib()[0]
                stack = stack.asRib()[1]
                pc = pc[2].asRib()
            }

            2 -> {  // get
                push(getOpND(o).asRib()[0])
                pc = pc[2].asRib()
            }

            3 -> {  // const
                push(o)
                pc = pc[2].asRib()
            }

            4 -> {  // if
                pc = pc[if (pop() === FALSE) 2 else 1].asRib()
            }

            // halt (exit)
            else -> break
        }
    }
}


@Suppress("UNCHECKED_CAST")
inline fun <reified T> T.asRib() = this as Rib


