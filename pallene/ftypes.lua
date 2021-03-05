-- Copyright (c) 2020, The Pallene Developers
-- Pallene is licensed under the MIT license.
-- Please refer to the LICENSE and AUTHORS files for details
-- SPDX-License-Identifier: MIT


local typedecl = require "pallene.typedecl"
local types = require "pallene.types"
local T = types.T


local ftypes = {}

local function declare_type(type_name, cons)
    typedecl.declare(ftypes, "ftypes", type_name, cons)
end

declare_type("FT", {
    CFloat     = {},
    CDouble    = {},

    CShort     = {},
    CInt       = {},
    CLong      = {},
    CLongLong  = {},

    CUShort    = {},
    CUInt      = {},
    CULong     = {},
    CULongLong = {},

    -- FVoid      = {},
    FFunction  = {"pln_func_type", "farg_types", "fret_type"}

    -- String     = {},
    -- Pointer    = {},

    -- Array      = {"elem"},
    -- Struct     = {"fields"},
})

declare_type("Modifier", {
    In        = {},
    Out       = {},
    Inout     = {},
    Ref       = {},
    None      = {},
})

declare_type("FArg", {
    Arg = {"ftype", "mod"},
})



local primitives = {
    ["float"]     = ftypes.FT.CFloat,
    ["double"]    = ftypes.FT.CDouble,

    ["short"]     = ftypes.FT.CShort,
    ["int"]       = ftypes.FT.CInt,
    ["long"]      = ftypes.FT.CLong,
    ["longlong"]  = ftypes.FT.CLongLong,

    ["ushort"]    = ftypes.FT.CUShort,
    ["uint"]      = ftypes.FT.CUInt,
    ["ulong"]     = ftypes.FT.CULong,
    ["ulonglong"] = ftypes.FT.CULongLong,
}

function ftypes.primitives()
    local ns = {}
    for n,f in pairs(primitives) do
        ns[n] = f()
    end
    return ns
end

function ftypes.modifier(name)
    if not name then
        return ftypes.Modifier.None()
    elseif name == "in" then
        return ftypes.Modifier.In()
    elseif name == "out" then
        return ftypes.Modifier.Out()
    elseif name == "inout" then
        return ftypes.Modifier.InOut()
    elseif name == "ref" then
        return ftypes.Modifier.Ref()
    else
        typedecl.tag_error(name)
    end
end


function ftypes.include_args(mod)
    local tag = mod._tag
    if     tag == "ftypes.Modifier.In" then
        return true
    elseif tag == "ftypes.Modifier.Out" then
        return false
    elseif tag == "ftypes.Modifier.InOut" then
        return true
    elseif tag == "ftypes.Modifier.Ref" then
        return true
    elseif tag == "ftypes.Modifier.None" then
        return true
    else
        typedecl.tag_error(tag)
    end
end

function ftypes.include_rets(mod)
    local tag = mod._tag
    if     tag == "ftypes.Modifier.In" then
        return false
    elseif tag == "ftypes.Modifier.Out" then
        return true
    elseif tag == "ftypes.Modifier.InOut" then
        return true
    elseif tag == "ftypes.Modifier.Ref" then
        return false
    elseif tag == "ftypes.Modifier.None" then
        return false
    else
        typedecl.tag_error(tag)
    end
end

function ftypes.pass_address(mod)
    local tag = mod._tag
    if     tag == "ftypes.Modifier.In" then
        return true
    elseif tag == "ftypes.Modifier.Out" then
        return true
    elseif tag == "ftypes.Modifier.InOut" then
        return true
    elseif tag == "ftypes.Modifier.Ref" then
        return true
    elseif tag == "ftypes.Modifier.None" then
        return false
    else
        typedecl.tag_error(tag)
    end
end


function ftypes.pln_type(ft)
    local tag = ft._tag
    if     tag == "ftypes.FT.CFloat" or
           tag == "ftypes.FT.CDouble" then
           return T.Float()

    elseif tag == "ftypes.FT.CShort" or
           tag == "ftypes.FT.CInt" or
           tag == "ftypes.FT.CLong" or
           tag == "ftypes.FT.CLongLong" or

           tag == "ftypes.FT.CUShort" or
           tag == "ftypes.FT.CUInt" or
           tag == "ftypes.FT.CULong" or
           tag == "ftypes.FT.CULongLong" then
       return T.Integer()


    -- elseif tag == "ftypes.FT.FVoid" then
    --     return T.Void()

    -- elseif tag == "ftypes.FT.String" then
    --     return T.String()

    -- elseif tag == "ftypes.FT.Pointer" then
    --     error("unimplemented")

    -- elseif tag == "ftypes.FT.Array"      then
    --     return ftypes.tostring(t.elem) .. "[]"

    -- elseif tag == "ftypes.FT.Struct"     then
    --     error("unimplemented")

    else
        typedecl.tag_error(tag)
    end
end

function ftypes.to_ctype(ft)
    local tag = ft._tag
    if     tag == "ftypes.FT.CFloat"     then return "float"
    elseif tag == "ftypes.FT.CDouble"    then return "double"

    elseif tag == "ftypes.FT.CShort"     then return "short"
    elseif tag == "ftypes.FT.CInt"       then return "int"
    elseif tag == "ftypes.FT.CLong"      then return "long"
    elseif tag == "ftypes.FT.CLongLong"  then return "longlong"

    elseif tag == "ftypes.FT.CUShort"    then return "ushort"
    elseif tag == "ftypes.FT.CUInt"      then return "uint"
    elseif tag == "ftypes.FT.CULong"     then return "ulong"
    elseif tag == "ftypes.FT.CULongLong" then return "ulonglong"

    -- elseif tag == "ftypes.FT.String"     then return "string"
    -- elseif tag == "ftypes.FT.Pointer"    then return "pointer"

    -- elseif tag == "ftypes.FT.Array"      then
    --     return ftypes.tostring(t.elem) .. "[]"

    -- elseif tag == "ftypes.FT.Struct"     then
    --     error("unimplemented")

    else
        typedecl.tag_error(tag)
    end
end

function ftypes.is_numeric(ft)
    local tag = ft._tag
    if     tag == "ftypes.FT.CFloat"     then return true
    elseif tag == "ftypes.FT.CDouble"    then return true

    elseif tag == "ftypes.FT.CShort"     then return true
    elseif tag == "ftypes.FT.CInt"       then return true
    elseif tag == "ftypes.FT.CLong"      then return true
    elseif tag == "ftypes.FT.CLongLong"  then return true

    elseif tag == "ftypes.FT.CUShort"    then return true
    elseif tag == "ftypes.FT.CUInt"      then return true
    elseif tag == "ftypes.FT.CULong"     then return true
    elseif tag == "ftypes.FT.CULongLong" then return true
    else
        return false
    end
end


return ftypes
