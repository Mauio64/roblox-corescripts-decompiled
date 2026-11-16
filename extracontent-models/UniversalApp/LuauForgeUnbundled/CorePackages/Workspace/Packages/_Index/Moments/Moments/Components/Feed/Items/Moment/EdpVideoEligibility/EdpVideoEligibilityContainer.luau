require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local useEdpVideoEligibilityViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment/EdpVideoEligibility/useEdpVideoEligibilityViewModel")

local function EdpVideoEligibilityContainer(data)
	local v5 = useEdpVideoEligibilityViewModel({ momentId = data.momentId, universeId = data.universeId })

	if v5.status == "Loading" then
		return data.loadingContent
	end

	if v5.status == "Eligible" then
		return data.content
	end

	return nil
end

return EdpVideoEligibilityContainer
