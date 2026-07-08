local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
local CallProtocol = require(CorePackages.Workspace.Packages.CallProtocol)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ContactList = RobloxGui.Modules.ContactList
local OpenOrUpdateDialog = require(ContactList.Actions.OpenOrUpdateDialog)
local dependencies = require(ContactList.dependencies)
local UIBlox = dependencies.UIBlox
local useSelector = dependencies.Hooks.useSelector
local useDispatch = dependencies.Hooks.useDispatch
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle
local ErrorType = require(ContactList.Enums.ErrorType)
local CloseDialog = require(ContactList.Actions.CloseDialog)
local useAnalytics = require(ContactList.Analytics.useAnalytics)
local EventNamesEnum = require(ContactList.Analytics.EventNamesEnum)
local v23 = game:DefineFastFlag("EnablePlatformNotSupportedError", false)
local t1 = {
	callProtocol = CallProtocol.CallProtocol.default
}

local function CallDialogContainer(t2: {[any]: any}) -- line: 44
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), useDispatch (copy), useAnalytics (copy), React (copy), useSelector (copy), CallProtocol (copy), ErrorType (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), EventNamesEnum (copy), v23 (copy), RunService (copy), Roact (copy), CoreGui (copy), InteractiveAlert (copy), ButtonType (copy), CloseDialog (copy)
	local v27 = Cryo.Dictionary.join(t1, t2)
	local Theme = useStyle().Theme
	local v29 = useDispatch()
	local v30 = useAnalytics()
	local v31, v32 = React.useState(Vector2.new(0, 0))
	local v33 = useSelector(function(p1) -- line: 55
		return p1.Dialog.title
	end, function(p2, p3) -- line: 57
		return p2 == p3
	end)
	local v34 = useSelector(function(p4) -- line: 61
		return p4.Dialog.bodyText
	end, function(p5, p6) -- line: 63
		return p5 == p6
	end)
	local v35 = useSelector(function(p7) -- line: 67
		return p7.Dialog.dismissCallback
	end, function(p8, p9) -- line: 69
		return p8 == p9
	end)
	local v36 = useSelector(function(p10) -- line: 73
		return p10.Dialog.isOpen
	end, function(p11, p12) -- line: 75
		return p11 == p12
	end)

	React.useEffect(function() -- line: 79
		-- upvalues: v27 (copy), CallProtocol (copy), ErrorType (copy), v29 (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), v30 (copy), EventNamesEnum (copy), v23 (copy), RunService (copy)
		local v49 = v27.callProtocol:listenToHandleCallMessage(function(p13) -- line: 80
			-- upvalues: CallProtocol (copy), ErrorType (copy), v29 (copy), OpenOrUpdateDialog (copy), RobloxTranslator (copy), v30 (copy), EventNamesEnum (copy), v23 (copy), RunService (copy)
			if p13.messageType == CallProtocol.Enums.MessageType.CallError.rawValue() then
				if p13.errorType == ErrorType.CallerIsInAnotherCall then
					v29(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Title.CouldntMakeCall"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.AlreadyInCall")))
				elseif p13.errorType == ErrorType.CalleeIsInAnotherCall then
					local calleeCombinedName = p13.callInfo.calleeCombinedName

					v29(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Title.FriendBusy"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.FriendBusy", {
						calleeCombinedName = calleeCombinedName
					})))
				elseif p13.errorType == ErrorType.UniverseIsNotVoiceEnabled or p13.errorType == ErrorType.PlaceIsNotVoiceEnabled then
					v29(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Title.ExperienceError"), RobloxTranslator:FormatByKey("Feature.Call.Description.ExperienceError")))
					v30.fireEvent(EventNamesEnum.PhoneBookCallFriendFailed, {
						errorMsg = "Universe or place is not voice enabled.",
						eventTimestampMs = os.time() * 1000,
						calleeUserId = p13.callInfo.calleeId,
						callerUserId = p13.callInfo.callerId
					})
				elseif p13.errorType == ErrorType.CallerIsNotVoiceEnabled then
					v29(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Modal.EnableChatVoiceTitle"), RobloxTranslator:FormatByKey("Feature.Call.Modal.EnableChatVoiceBody")))
					v30.fireEvent(EventNamesEnum.PhoneBookCallFriendFailed, {
						errorMsg = "User is not voice enabled.",
						eventTimestampMs = os.time() * 1000,
						calleeUserId = p13.callInfo.calleeId,
						callerUserId = p13.callInfo.callerId
					})
				else
					v29(OpenOrUpdateDialog(RobloxTranslator:FormatByKey("Feature.Call.Error.Label.OhNo"), RobloxTranslator:FormatByKey("Feature.Call.Error.Description.Generic")))
				end

				if p13.errorType == ErrorType.UniverseAgeIsNotValid then
					warn("Experience must be at least one week old to place a call")

					return
				end

				if p13.errorType == ErrorType.ReservedServerAccessCodeIsNotProvided then
					warn("Reserved server access code was not provided via OnCallInviteInvoked callback")

					return
				end

				if v23 and p13.errorType == ErrorType.PlatformIsNotSupported and RunService:IsStudio() then
					warn("Roblox Studio requires Team Test to place a call.")
				end
			end
		end)

		return function() -- line: 155
			-- upvalues: v49 (copy)
			v49:Disconnect()
		end
	end, { v27.callProtocol })

	return React.createElement(Roact.Portal, {
		target = CoreGui
	}, {
		CallDialogScreen = React.createElement("ScreenGui", {
			Enabled = v36,
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			AutoLocalize = false,
			DisplayOrder = 8,
			[React.Change.AbsoluteSize] = function(p14) -- line: 170
				-- upvalues: v32 (copy)
				v32(p14.AbsoluteSize)
			end
		}, {
			Overlay = React.createElement("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = "",
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = Theme.Overlay.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}),
			CallDialog = React.createElement(InteractiveAlert, {
				screenSize = v31,
				title = v33,
				bodyText = v34,
				buttonStackInfo = {
					buttons = {{
						buttonType = ButtonType.PrimarySystem,
						props = {
							text = RobloxTranslator:FormatByKey("InGame.CommonUI.Button.Ok"),
							onActivated = function() -- line: 192
								-- upvalues: v35 (copy), v29 (copy), CloseDialog (copy)
								if v35 then
									v35()
								end

								v29(CloseDialog())
							end
						}
					}}
				}
			})
		})
	})
end

return CallDialogContainer
