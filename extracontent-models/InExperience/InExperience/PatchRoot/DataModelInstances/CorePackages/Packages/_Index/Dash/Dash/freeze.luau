local parent = script.Parent
local Error = require(parent.Error)
local format = require(parent.format)

local readonlyKey = Error.new(
	"ReadonlyKey",
	"Attempted to write to readonly key {key:?} of frozen object {objectName:?}"
)
local missingKey = Error.new("MissingKey", "Attempted to read missing key {key:?} of frozen object {objectName:?}")

local function freeze(objectName: string, list, flag: boolean?)
	local v = {}

	assert(
		type(list) == "table",
		`Attempted to call Dash.freeze with argument #2 of type {type(list)}, but it should be table `
	)

	setmetatable(v, {
		__index = function(_, p)
			local item = list[p]

			if item == nil and flag then
				missingKey:throw({ key = p, objectName = objectName })
			end

			return item
		end,
		__newindex = function(_, p)
			readonlyKey:throw({ key = p, objectName = objectName })
		end,
		__len = function()
			return #list
		end,
		__tostring = function()
			return format("Frozen({})", objectName)
		end,
		__call = function(_, ...)
			return list(...)
		end
	})

	return v
end

return freeze
