local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local sendrPostStatusToast = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusToast/sendrPostStatusToast")

local function PostStatusToastEventReceiver(): nil
	React.useEffect(function()
		return sendrPostStatusToast.listen(function(p2)
			if not sendrPostStatusToast.isFailure(p2) then
				sendrPostStatusToast.dismiss(p2)
			end
		end)
	end, {})
	return nil
end

return PostStatusToastEventReceiver
