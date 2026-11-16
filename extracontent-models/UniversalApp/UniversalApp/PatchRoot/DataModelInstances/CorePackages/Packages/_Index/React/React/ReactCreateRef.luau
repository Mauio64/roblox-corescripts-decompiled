local parent = script.Parent.Parent
local ReactGlobals = require(parent.ReactGlobals)
local Shared = require(parent.Shared)

local enableAllocationTrims = Shared.ReactFeatureFlags.enableAllocationTrims

local ReactBindingroblox = require(script.Parent["ReactBinding.roblox"])

local ReactCreateRef = {
	createRef = function()
		local v, _ = ReactBindingroblox.create(nil)

		local v2 = {}

		if ReactGlobals.__DEV__ then
			v._source = debug.traceback("Ref created at:", 1)
		end

		setmetatable(v2, {
			__index = function(_, p)
				if p == "current" then
					return v:getValue()
				end

				return v[p]
			end,
			__newindex = function(_, p, p2)
				if p == "current" then
					ReactBindingroblox.update(v, p2)
				end

				v[p] = p2
			end,
			__tostring = function(_)
				return string.format("Ref(%s)", (tostring(v:getValue())))
			end
		})

		return v2
	end
}

local function refNewIndex(p, p2, p3)
	local __index = getmetatable(p).__index
	__index[p2] = p3

	if p2 == "current" then
		ReactBindingroblox.update(__index, p3)
	end
end

local function refToString(p)
	return string.format("Ref(%s)", (tostring(getmetatable(p).__index:getValue())))
end

local function createRefWithoutClosures()
	local v

	if ReactGlobals.__DEV__ then
		v = debug.traceback("Ref created at:", 1)
	end

	return (setmetatable({}, {
		__index = ReactBindingroblox.createWithoutUpdater(nil, v),
		__newindex = refNewIndex,
		__tostring = refToString
	}))
end

if enableAllocationTrims then
	ReactCreateRef.createRef = createRefWithoutClosures
end

return ReactCreateRef
