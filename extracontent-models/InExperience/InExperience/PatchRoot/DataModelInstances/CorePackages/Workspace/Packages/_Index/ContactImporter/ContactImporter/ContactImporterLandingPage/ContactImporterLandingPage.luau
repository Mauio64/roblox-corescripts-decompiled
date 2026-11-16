local ContactImporter = script:FindFirstAncestor("ContactImporter")
local parent = ContactImporter.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation

local useBeginContactImporter = require(ContactImporter.Hooks.useBeginContactImporter)

local function ContactImporterLandingPage()
	local _, v = useBeginContactImporter({
		entryPoint = (useNavigation().getParam("extraProps") or {}).entryPoint
	})

	local v2 = React.useCallback(function()
		if v then
			v()
		end
	end, { v })

	React.useEffect(function()
		v2()
	end, {})
end

return ContactImporterLandingPage
