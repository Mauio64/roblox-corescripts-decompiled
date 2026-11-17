local parent = script:FindFirstAncestor("Moments").Parent

local React = require(parent.React)

local sendrPostStatusToast = require(script.Parent.sendrPostStatusToast)

local function PostStatusToastEventReceiver(): nil
	React.useEffect(function()
		return sendrPostStatusToast.listen(function(p)
			if not sendrPostStatusToast.isFailure(p) then
				sendrPostStatusToast.dismiss(p)
			end
		end)
	end, {})
	return nil
end

return PostStatusToastEventReceiver
