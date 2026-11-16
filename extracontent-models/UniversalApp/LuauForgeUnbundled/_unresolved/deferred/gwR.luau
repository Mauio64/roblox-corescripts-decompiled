local module = require("@luauforge/deferred/gwS")
local module2 = require("@luauforge/deferred/gxa")
local module3 = require("@luauforge/deferred/gxb")

local module4 = require("@luauforge/deferred/gwU")

local module5 = require("@luauforge/deferred/gwV")
local useEffect = module5.useEffect
local useRoactService = require("@luauforge/deferred/gxj").useRoactService
local appLogging = require("@luauforge/deferred/gxk").AppLogging

local module6 = require("@luauforge/deferred/gwZ")
local dialog = module6.Dialog
local dialogSize = module6.Enums.DialogSize
local view = module6.View

local function AccountLockModal(props)
	local v5 = useRoactService(appLogging)
	local module7 = require("@luauforge/deferred/gxd")
	local accountLockEventContextEnum = require("@luauforge/deferred/gwT").AccountLockEventContextEnum

	useEffect(function()
		v5:logRobloxTelemetryEvent(module7, {}, {
			context = accountLockEventContextEnum.Init
		})
	end, nil)

	return module5.createElement(module4.Provider, {}, {
		children = module5.createElement(dialog.Root, { size = dialogSize.Medium }, {
			DialogTitle = module5.createElement(module, {}),
			DialogContent = module5.createElement(dialog.Content, nil, {
				DialogView = module5.createElement(
					view,
					{ tag = "col fill auto-xy items-start gap-medium" },
					{
						DialogContentText = module5.createElement(module2, {}),
						DialogFooter = module5.createElement(module3, {
							Logout = props.Logout,
							ResetNavigationHistory = props.ResetNavigationHistory,
							ApiFetchAccessStatus = props.ApiFetchAccessStatus,
							ChallengeError = props.ChallengeError,
							closeCentralOverlayThunk = props.closeCentralOverlayThunk
						})
					}
				)
			})
		})
	})
end

return module5.memo(AccountLockModal)
