local parent = script:FindFirstAncestor("Moments").Parent

require(parent.React)

local useEdpVideoEligibilityViewModel = require(script.Parent.useEdpVideoEligibilityViewModel)

local function EdpVideoEligibilityContainer(data)
	local v = useEdpVideoEligibilityViewModel({
		momentId = data.momentId,
		universeId = data.universeId
	})

	if v.status == "Loading" then
		return data.loadingContent
	end

	return if v.status == "Eligible" then data.content else nil
end

return EdpVideoEligibilityContainer
