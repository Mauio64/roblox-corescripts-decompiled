local CorePackages = game:GetService("CorePackages")

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon.SettingsShowSignal

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)

local parent = script.Parent.Parent

local EnumReactPage = require(parent.EnumReactPage)
local PortalWithFoundationStylelink = require(parent.Components.PortalWithFoundationStylelink)
local ReactPageSignal = require(parent.ReactPageSignal)
local Traversal = require(parent.Components.Traversal)

local TraversalHistoryPage = Traversal.TraversalHistoryPage

local function InExperienceMenuReactPage(props, _)
	local reactPageSignal = ReactPageSignal(false)
	local v = SignalsReact.useSignalState(reactPageSignal.currentReactPage)
	local page

	if v == EnumReactPage.TraversalHistory then
		page = React.createElement(TraversalHistoryPage)
	end

	React.useEffect(function()
		if not v then
			return
		end

		props.onMount()
		return props.onUnmount
	end, { v })

	React.useEffect(function()
		local connection = SettingsShowSignal:connect(function(p)
			if not p then
				props.onUnmount()
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	return React.createElement(PortalWithFoundationStylelink, { parent = props.mountTo }, {
		Page = page
	})
end

return React.memo(React.forwardRef(InExperienceMenuReactPage))
