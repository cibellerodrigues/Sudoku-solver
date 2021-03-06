import sys
from copy import deepcopy


def read_cnf(filename):
    clauses = []
    with open(filename) as f:
        line1 = f.readline().split(' ')
        atomos = int(line1[0])
        clause = int(line1[1])

        for line in f:
            clauses.append([int(i) for i in line.split()])

    return clauses


def find_unit_clauses(clauses):
    unit_dict = {}
    for clause in clauses:
        if len(clause) == 1:
            unit_dict[clause[0]] = 1
    
    unit_clauses = []

    for key, value in unit_dict.items():
        unit_clauses.append(key)
    return unit_clauses


def empty_clause(clauses):
    for clause in clauses:
        if not clause:
            return True
    return False


def remove(unit, clauses):
    return [i for i in clauses if i and (unit not in i)]

def remove_negative(unit, clauses):
    return [[ i for i in clause if i != unit ] for clause in clauses]

def simplifies(formula, unit_clauses):
    for l in unit_clauses:
        formula = remove(l, formula)
        formula = remove_negative(-l, formula)
    return formula

def dpll(old_formula, old_val, recursion_depth):

    global result
    formula = deepcopy(old_formula)
    val = deepcopy(old_val)

    # print "\n# Recursion Depth ", recursion_depth
    # print "# formula",formula
    
    
    unit_clauses = find_unit_clauses(formula)
    for unit_clause in unit_clauses:
        val.append(unit_clause)
    # print "#unit clauses: ", unit_clauses
    formula = simplifies(formula, unit_clauses)
    
    # print "# formula simplificada: ",formula
    # print "#valoracoes: ", val

    if(formula == []):
	    result = deepcopy(val)
	    return True
    elif(empty_clause(formula)):
	    return False
    else:
        I = formula[0][0]
    if(dpll(formula+[[I]],val, recursion_depth+1)):
		return True
    elif(dpll(formula+[[-I]],val,recursion_depth+1)):
		return True
    else:
		return False



def main():
    formula = read_cnf("a.txt")
    satisfabilidade = dpll(formula,[], 0)

    if satisfabilidade:
        print "************ SAT"

        with open('a-result.txt', 'w') as f:
            for element in result:
                if element > 0:
                    f.write(str(element)+' '+'\n')

    else:
        print "************ UNSAT"

if __name__ == "__main__":
    main()