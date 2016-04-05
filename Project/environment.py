from lexeme import Lexeme

class Environment():

    def __init(self):
        self.globalenv = create()

    def cons(self, value, left, right):
        # return ConsCell(value, ConsCell(left, ConsCell(right, None)))
        return ConsCell(value, left, ConsCell("JOIN", right, None))

    def car(self, lyst):
        return lyst.left

    def cdr(self, lyst):
        return lyst.right

    def cadr(self, lyst):
        return lyst.right.left

    def setCar(self, lyst, value):
        lyst.left = value
        return lyst

    def setCdr(self, lyst, value):
        lyst.right = value
        return lyst

    def sameVariable(self, var1, var2):
        return str(var1).equal(str(var2))


    def create(self):
        return self.extend(None, None, None)

    def lookup(self, variable, env):
        while (env != None):
            variables = self.car(env)
            vals = self.cadr(env)
            while (variables != None):
                if (self.sameVariable(variable, self.car(variables))):
                    return self.car(vals)
                variables = self.cdr(variables)
                vals = self.cdr(vals)
            env = self.cdr(self.cdr(env))

        print("variable ",variable," is undefined");
        return None;

    def update(self, variable, env):
        while (env != None):
            variables = self.car(env)
            vals = self.cadr(env)
            while (variables != None):
                if (self.sameVariable(variable, self.car(variables))):
                    self.setCar(vals, variable)
                variables = self.cdr(variables)
                vals = self.cdr(vals)
            env = self.cdr(self.cdr(env))

        print("variable ",variable," is undefined");

    def insert(self, variable, value, env):
        self.setCar(env, self.cons("JOIN", variable, self.car(env)))
        self.setCar(self.cdr(env), self.cons("JOIN", value, self.cadr(env)))
        return value

    def extend(self, variables, values, env):
        return self.cons("ENV", variables, self.cons("ENV", values, env))
