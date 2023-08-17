### Resolution Theorem Prover for Propositional Logic in Prolog

This Prolog program serves as a resolution theorem prover for propositional logic. It transforms input formulas into conjunctive normal form (CNF) and then employs the resolution proof method to determine if a given formula has a propositional proof.

## Operators

### Unary Operators: 
  -neg: This unary operator represents the logical negation or NOT operation. It takes a single formula as an operand and produces the logical negation of that formula. For example, if P is a formula, then neg P represents "not P" or "¬P".

### Binary Operators:

  -and: The binary operator and represents the logical AND operation. It takes two formulas as operands and produces the logical conjunction of those formulas. For example, if P and Q are formulas, then P and Q represents "P AND Q".
  -or: The binary operator or represents the logical OR operation. It takes two formulas as operands and produces the logical disjunction of those formulas. For example, if P and Q are formulas, then P or Q represents "P OR Q".
  -imp: The binary operator imp represents the logical implication operation. It takes two formulas as operands and produces the implication of the first formula by the second formula. For example, if P and Q are formulas, then P imp Q represents "P IMPLIES Q".
  -revimp: The binary operator revimp represents the reverse implication operation. It takes two formulas as operands and produces the reverse implication of the first formula by the second formula. For example, if P and Q are formulas, then P revimp Q represents "P REVERSE IMPLIES Q".
  -uparrow: The binary operator uparrow represents the logical NAND operation. It takes two formulas as operands and produces the logical NAND of those formulas. For example, if P and Q are formulas, then P uparrow Q represents "P NAND Q".
  -downarrow: The binary operator downarrow represents the logical NOR operation. It takes two formulas as operands and produces the logical NOR of those formulas. For example, if P and Q are formulas, then P downarrow Q represents "P NOR Q".
  -notimp: The binary operator notimp represents the logical NOT implication operation. It takes two formulas as operands and produces the logical NOT implication of those formulas. For example, if P and Q are formulas, then P notimp Q represents "P NOT IMPLIES Q".
  -notrevimp: The binary operator notrevimp represents the logical NOT reverse implication operation. It takes two formulas as operands and produces the logical NOT reverse implication of those formulas. For example, if P and Q are formulas, then P notrevimp Q represents "P NOT REVERSE IMPLIES Q".

#### Step-by-Step Guide

1. **CNF Transformation**
   - The initial step involves transforming a given propositional formula into CNF using the provided guidelines and the example program in Section 2.9 of Fitting's book.
   - The program defines the unary operator `neg` and binary operators `and`, `or`, `imp`, `revimp`, `uparrow`, `downarrow`, `notimp`, and `notrevimp`.
   - Predicates such as `conjunctive/1`, `disjunctive/1`, `components/3`, and `component/2` are reused from the example program to recognize and split formulas.
   - The interface predicate is `clauseform(X, Y)`, where Y is the CNF of the formula X.

2. **Handling Secondary Connectives**
   - Extend the program to handle the secondary binary operators `equiv` and `notequiv` using the definitions in Table 2.1 of the book.

3. **Resolution Proof**
   - Implement the atomic resolution rule using predicates `resolutionstep/2` and `resolution/2` similar to the example predicates `singlestep/2` and `expand/2`.
   - Check for closed resolution expansion as described in Section 3.3 of the book.

4. **Main Predicate**
   - The main predicate is `test/1`, which takes a propositional formula as input and prints "YES" if a propositional proof exists, and "NO" otherwise.

#### Usage

1. Define a propositional formula in the `test/1` predicate by providing the formula as an argument. For example:
   ```prolog
   ?- test("((x imp y) and x) imp y").
   ```
2. Run the program. It will print "YES" if the formula has a propositional proof, and "NO" otherwise.

#### Test Data

Use the provided test data to determine which of the following formulas are theorems:
1. ((x imp y) and x) imp y
2. (neg x imp y) imp (neg (x notimp y) imp y)
3. ((x imp y) and (y imp z)) imp (neg neg z or neg x)
4. (x imp (y imp z)) equiv ((x imp y) imp z)
5. (x notequiv y) equiv (y notequiv x)
6. (x notequiv (y notequiv z)) equiv ((x notequiv y) notequiv z)
7. (neg x downarrow neg y) revimp neg (x uparrow y)
8. (neg x revimp neg y) and ((z notrevimp u) or (u uparrow neg v))
9. ((x or y) imp (neg y notrevimp z)) or (neg neg (z equiv x) notrevimp y)
10. (neg (z notrevimp y) revimp x) imp ((x or w) imp ((y imp z) or w))

#### Efficiency Considerations

You can enhance the efficiency of the program by incorporating strategies to eliminate duplicate variables and clauses early in the resolution process.

Please ensure that you have a Prolog interpreter/environment set up to execute the program. Modify and expand the program as needed to accommodate additional operators or proof methods.
