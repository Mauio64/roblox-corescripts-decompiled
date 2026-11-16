local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/RoactUtils").Hooks.RoactRodux.useDispatch
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/RobloxAppEnums").AppPage
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/ToastRodux").Actions.SetCurrentToastMessage
local images = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/UIBlox").App.ImageSet.Images
local fFlagMomentsBlockingModalInOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SharedFlags").FFlagMomentsBlockingModalInOverlay

local function useOpenBlockingModal(p2)
	local v5 = useDispatch()
	local v6 = React.useCallback(function(data)
		p2.push(appPage.BlockingModal, {
			navProps = {
				userId = data.userId,
				onBlockConfirmed = data.onBlockConfirmed,
				onBlockFailed = data.onBlockFailed,
				openReportUser = data.openReportUser,
				presentInOverlay = fFlagMomentsBlockingModalInOverlay and true or nil,
				onBlockSuccess = function()
					v5(setCurrentToastMessage({
						toastMessage = "Feature.Profile.Action.UserBlocked",
						toastIcon = images["icons/actions/block"]
					}))

					if data.onBlockSucceeded ~= nil then
						data.onBlockSucceeded()
					end
				end
			}
		})
	end, { p2, v5 })

	if p2 == nil then
		return nil
	end

	return v6
end

return useOpenBlockingModal
