---@diagnostic disable: need-check-nil
--- @param filepath string path to the json file to parse, relative to the directory from where the tests are run
--- @return snoogle.hoogle.SearchItem
local function read_json(filepath)
	local fs = io.open(filepath, "r")
	assert.truthy(fs)
	local json_bs = fs:read("*a")
	io.close(fs)

	local json = vim.json.decode(json_bs)
	assert.truthy(json)
	return json
end

describe("Parse & Convert Hoogle Data", function()
	it("should parse symbol", function()
		local json = read_json("tests/assets/symbol.json")
		assert.truthy(json)
		local item = require("snoogle.core.model").from_hoogle(json)

		assert.is_not_nil(item)
		assert.is_nil(item.pkg)
		assert.is_nil(item.module)

		--- @type snoogle.SearchItem.Symbol
		local symbol = item.symbol
		assert.are.equal("fmap", symbol.name)
		assert.are.equal("fmap :: Functor f => (a -> b) -> f a -> f b", symbol.decl)
		assert.are.equal("Prelude", symbol.module.name)
		assert.are.equal("base", symbol.module.package.name)
	end)

	it("should parse module", function()
		local json = read_json("tests/assets/module.json")
		assert.truthy(json)
		local item = require("snoogle.core.model").from_hoogle(json)

		assert.is_not_nil(item)
		assert.is_nil(item.pkg)
		assert.is_nil(item.symbol)

		--- @type snoogle.SearchItem.Module
		local module = item.module
		assert.are.equal("Prelude", module.name)
		assert.are.equal("https://hackage.haskell.org/package/base/docs/Prelude.html", module.url)
		assert.are.equal("base", module.package.name)
	end)

	it("should parse package", function()
		local json = read_json("tests/assets/package.json")
		assert.truthy(json)
		local item = require("snoogle.core.model").from_hoogle(json)

		assert.is_not_nil(item)
		assert.is_nil(item.module)
		assert.is_nil(item.symbol)

		--- @type snoogle.SearchItem.Package
		local pkg = item.pkg
		assert.are.equal("base", pkg.name)
		assert.are.equal("https://hackage.haskell.org/package/base", pkg.url)
	end)

	describe("Isolate symbol name", function()
		local f = require("snoogle.core.model").isolate_symbol_name
		local test = function(t_name, input, expected)
			return it(t_name, function()
				assert.are.equal(expected, f(input))
			end)
		end
		test("Function", "id :: a -> a", "id")
		test("Class", "class Functor f", "Functor")
		test("Newtype", "newtype ExceptT e (m :: Type -> Type) a", "ExceptT")
		test("Type Synonym", "type DecsQ = Q [Dec]", "DecsQ")
		test("Type Synonym with arg", "type S a = Maybe a", "S")
		test("Data with context", "data Cxt x => T x", "T")
		test("Newtype with context", "newtype Cxt x => T x", "T")
		test("Class with context", "class Applicative m => Monad (m :: Type -> Type)", "Monad")
	end)
end)
