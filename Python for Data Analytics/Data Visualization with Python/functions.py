#  function that replaces 'k' or 'm' character with numerical value of cell as float dtype
def conv(string):
    if string[-1].lower() == 'k':
        return float(string.replace('k', ''))*1000
    elif string[-1].lower() == 'm':
        return float(string.replace('m', ''))*1000000
    else:
        return float(string)
