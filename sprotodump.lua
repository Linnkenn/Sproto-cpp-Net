local parse_core = require "core"
local parse_param = require "param"
local util = require "util"

------------------------------- readme -------------------------------------
local README = [[
sprotodump is a simple tool to convert sproto file to spb binary.

usage: lua sprotodump.lua <option> <sproto_file1 sproto_file2 ...> [ [<out_option> <outfile>] ...] [namespace_option]

    option: 
        -cs              dump to cSharp code file
        -spb             dump to binary spb  file
        -go              dump to go code file
        -cxx             dump to c++ code file

    out_option:
        -d <dircetory>               dump to speciffic dircetory
        -o <file>                    dump to speciffic file
        -p <package name>            set package name(only cSharp code use)

    namespace_option:
        -namespace       add namespace to type and protocol
  ]]


------------------------------- module -------------------------------------
local module = {
  ["-cs"] = require "module.cSharp",
  ["-spb"] = require "module.spb",
  ["-go"] = require "module.go",
  ["-cxx"] = require "module.cxx",
}


------------------------------- param -------------------------------------
local param = parse_param(...)
if not param or not module[param.dump_type] then
  print(README)
  return
end

------------------------------- parser -------------------------------------
local function _gen_trunk_list(sproto_file, namespace)
  local trunk_list = {}
  for i,v in ipairs(sproto_file) do
    namespace = namespace and util.file_basename(v) or nil
    table.insert(trunk_list, {util.read_file(v), v, namespace})
  end
  return trunk_list
end
print("param is ")
for k,v in pairs(param) do
  print(k,v)
end
print("param end")
local m = module[param.dump_type]
local trunk_list = _gen_trunk_list(param.sproto_file, param.namespace)
print("trunk list is ")
for k,v in pairs(trunk_list) do
  print(k,v)
end
local trunk, build = parse_core.gen_trunk(trunk_list)
print("trunk is ", trunk, build)
m(trunk, build, param)
