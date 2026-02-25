import random
import pandas as pd
import halo  # LINT WARN: unused import (F401)

# VENV: swap imports above to verify active venv


# TREESITTER: _pool() is a level-3 fold — closed at foldlevel=2, use zc/zo/zm/zR
def make_df():
    l = 1  # LINT: unused (F841) + ambiguous name (E741) | DAP: virtual text visible here
    def _cols():  # level 2, open
        names = ["Alice","Bob","Charlie","Diana","Eve"]  # FORMAT: run :lua vim.lsp.buf.format()
        cats  = ["A","B","C","D","E"]
        nums  = range(1,100)
        def _pool(i):  # level 3, closed at foldlevel=2
            return [names,cats,nums][i%3]
        return {f"col_{i}": [random.choice(list(_pool(i))) for _ in range(50000)] for i in range(20)}
    df = pd.DataFrame(_cols())
    try:
        df.to_csv("df.csv",index=False)
    except:  # LINT HINT: bare except (E722)
        pass
    return df


# LINT ERROR: undefined name (F821)
def will_crash():
    print(undefined_variable)


if __name__ == "__main__":
    df = make_df()
    print(df)
