local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local Modules = CoreGui.RobloxGui.Modules
local makeEvents = require(Modules.AvatarExperience.Common.Util.makeEvents)
local BodyDataCallbacksContext = require(script.Parent.BodyDataCallbacksContext)
local BodyDataEventsContext = require(script.Parent.BodyDataEventsContext)
local t1 = { "setBodyColors" }

if require(Modules.AvatarExperience.Flags.FFlagAXFixBodyScaleReduxUpdates) then
	table.insert(t1, "setAvatarScales")
end

return function(p1) -- line: 26
	-- upvalues: React (copy), makeEvents (copy), t1 (copy), BodyDataCallbacksContext (copy), BodyDataEventsContext (copy)
	local v10, v11 = React.useState({})
	local v12, v13 = React.useState({})

	React.useEffect(function() -- line: 30
		-- upvalues: makeEvents (copy), t1 (copy), v11 (copy), v13 (copy)
		local v14, v15, v16 = makeEvents(t1)

		v11(v14)
		v13(v15)

		return function() -- line: 34
			-- upvalues: v16 (copy)
			for _, v18 in v16 do
				v18()
			end
		end
	end, {})

	return React.createElement(BodyDataCallbacksContext.Provider, {
		value = v12
	}, {
		BodyDataEventsContextProvider = React.createElement(BodyDataEventsContext.Provider, {
			value = v10
		}, p1.children)
	})
end
