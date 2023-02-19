# RVM Feature Proposal: Foreign Objects

## Intro to Foreign Objects

Currently, the Ribbit Virtual Machine (RVM) suffers from.

The foreign objects proposal aimed to behave mostly like the other rib types supported by the RVM to make their
integration as seamless as possible.

## Integration into the RVM standard / What do a Foreign Object look like?

### Foreign Object rib representation

A foreign object would be represented as a rib of the form:

|   value    |        useful-meta-info        | code |
|:----------:|:------------------------------:|:----:|
| native-obj | implementation-dependant-value |  6   |

Let's analyse the implication of this form-factor. First, why choose 6 as the code value? Well, because the RVM standard
already specify what the rib representation of the values 0-5 should be, 6 is the next available code, so we claim this
value to represent foreign objects.

### New RVM standard primitives to work with Foreign Objects

There are a couple of new primitives that need to be integrated directly into the RVM standard to make the integration
of Foreign Objects possible:

- `foreign`: `rib(pop(), ANY, 6)`

## Integration with regular objects

## Implementation for an RVM in a language without a GC

It is recommended to store the foreign object's size into the second field of the rib to be able to easily free it.

## Implementation for an RVM in a language with a GC

The second field can be used to make some optimization. For example,

## Future Work

Foreign Objects open the door to a lot of features and optimization inside the RVM. However, as it is right now, the
Foreign Object Proposal doesn't require any RVM implementation to support specific standard Foreign Objects. Those
standard Foreign Objects could be an opportunity to make a lot of cross-platform optimizations that are currently
impossible right now. Examples of such Foreign Objects could be `native` representation of things like `string`
and `vectors`, which are currently a big bottleneck in the RVM speed and effectiveness.