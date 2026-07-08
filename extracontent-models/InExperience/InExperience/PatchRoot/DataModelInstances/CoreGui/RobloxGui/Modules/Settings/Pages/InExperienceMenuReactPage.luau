local CorePackages = game:GetService("CorePackages")
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local ParentParent = script.Parent.Parent
local EnumReactPage = require(ParentParent.EnumReactPage)
local PortalWithFoundationStylelink = require(ParentParent.Components.PortalWithFoundationStylelink)
local ReactPageSignal = require(ParentParent.ReactPageSignal)
local TraversalHistoryPage = require(ParentParent.Components.Traversal).TraversalHistoryPage

local function InExperienceMenuReactPage(t1: {[any]: any}, _) -- line: 25
	-- upvalues: ReactPageSignal (copy), SignalsReact (copy), EnumReactPage (copy), React (copy), TraversalHistoryPage (copy), SettingsShowSignal (copy), PortalWithFoundationStylelink (copy)
	local v13 = ReactPageSignal(false)
	local v14 = SignalsReact.useSignalState(v13.currentReactPage)
	local v15 = nil

	if v14 == EnumReactPage.TraversalHistory then
		v15 = React.createElement(TraversalHistoryPage)
	end

	React.useEffect(function() -- line: 34
		-- upvalues: v14 (copy), t1 (copy)
		if v14 then
			t1.onMount()

			return t1.onUnmount
		end
	end, { v14 })
	React.useEffect(function() -- line: 42
		-- upvalues: SettingsShowSignal (copy), t1 (copy)
		local v16 = SettingsShowSignal:connect(function(p2) -- line: 43
			-- upvalues: t1 (copy)
			if not p2 then
				t1.onUnmount()
			end
		end)

		return function() -- line: 48
			-- upvalues: v16 (copy)
			v16:Disconnect()
		end
	end, {})

	return React.createElement(PortalWithFoundationStylelink, {
		parent = t1.mountTo
	}, {
		Page = v15
	})
end

return React.memo(React.forwardRef(InExperienceMenuReactPage))
