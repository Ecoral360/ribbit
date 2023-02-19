# RVM Feature Proposal for Foreign Objects

## Intro to Foreign Objects

Currently, the Ribbit Virtual Machine (RVM) suffers from.

The foreign objects proposal aimed to behave mostly like the other rib types supported by the RVM to make the
integration as seamless as possible.

## Integration with regular objects

## Integration into the RVM standard

A foreign object would be represented as a rib of the form:

|   value    |        useful-meta-info        | code |
|:----------:|:------------------------------:|:----:|
| native-obj | implementation-dependant-value |  6   |

Let's analyse the implication of this form-factor. First, why choose 6 as the code value? Well, because the RVM standard
already specify what the rib representation of the values 0-5 should be, 6 is the next available code, so we claim this
value to represent foreign objects.

## Implementation for an RVM in a language without a GC

It is recommended to store the foreign object's size into the second field of the rib to be able to easily free it.

## Implementation for an RVM in a language with a GC

The second field can be used to make some optimization. For example,  
