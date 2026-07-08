local ContactImporter = script:FindFirstAncestor("ContactImporter")
local ContactImporterParent = ContactImporter.Parent
local React = require(ContactImporterParent.React)
local useNavigation = require(ContactImporterParent.Navigation).useNavigation
local useBeginContactImporter = require(ContactImporter.Hooks.useBeginContactImporter)

local function ContactImporterLandingPage() -- line: 10
	-- upvalues: useNavigation (copy), useBeginContactImporter (copy), React (copy)
	local entryPoint = (useNavigation().getParam("extraProps") or {}).entryPoint
	local _, v9 = useBeginContactImporter({
		entryPoint = entryPoint
	})
	local v10 = React.useCallback(function() -- line: 17
		-- upvalues: v9 (copy)
		if v9 then
			v9()
		end
	end, { v9 })

	React.useEffect(function() -- line: 23
		-- upvalues: v10 (copy)
		v10()
	end, {})
end

return ContactImporterLandingPage
