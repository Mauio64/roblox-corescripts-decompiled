local parent = script:FindFirstAncestor("MomentsCommon").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local UIBlox = require(parent.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsBlockingModalInOverlay = SharedFlags.FFlagMomentsBlockingModalInOverlay

local function useOpenBlockingModal(p)
	local v = useDispatch()
	local v2 = React.useCallback(function(data)
		p.push(AppPage.BlockingModal, {
			navProps = {
				userId = data.userId,
				onBlockConfirmed = data.onBlockConfirmed,
				onBlockFailed = data.onBlockFailed,
				openReportUser = data.openReportUser,
				presentInOverlay = FFlagMomentsBlockingModalInOverlay and true or nil,
				onBlockSuccess = function()
					v(SetCurrentToastMessage({
						toastMessage = "Feature.Profile.Action.UserBlocked",
						toastIcon = Images["icons/actions/block"]
					}))

					if data.onBlockSucceeded ~= nil then
						data.onBlockSucceeded()
					end
				end
			}
		})
	end, { p, v })
	return if p ~= nil then v2 else nil
end

return useOpenBlockingModal
