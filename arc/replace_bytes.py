import os
path = "./"

def replace_bytes(findstring, replacestr, path):
    for subdirectory, directory, files in os.walk(path):
        for file in files:
            with open(subdirectory + "/" + file, "rb") as f:
                s = f.read()
                index = s.find(findstring)
                if index > -1:
                    replaced_str = s.replace(findstring, replacestr)
                    new_file_name = file
                    new_path = "./" + subdirectory + "/"
                    with open(new_path + new_file_name, "wb") as f:
                        f.write(replaced_str)

findstring = b'\x0E\x32\x00\x28'
replacestr = b'\x1B\x1F\x1B\x1F'
replace_bytes(findstring, replacestr, path)
