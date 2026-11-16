local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ContactImporter/Navigation").useNavigation

local useBeginContactImporter = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Hooks/useBeginContactImporter")

local function ContactImporterLandingPage()
	local v5, v6 = useBeginContactImporter({
		entryPoint = (useNavigation().getParam("extraProps") or {}).entryPoint
	})

	local v7 = React.useCallback(function()
		if v6 then
			v6()
		end
	end, { v6 })

	React.useEffect(function()
		v7()
	end, {})
end

return ContactImporterLandingPage
