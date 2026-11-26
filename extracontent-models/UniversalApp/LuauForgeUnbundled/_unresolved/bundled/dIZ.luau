local module = require("@luauforge/bundled/dJa")
local module2 = require("@luauforge/bundled/dJb")
local module3 = require("@luauforge/bundled/dJc")
local navigateSideways = require("@luauforge/bundled/dJd").Thunks.NavigateSideways
local fFlagSignalsNavP3Dispatch = require("@luauforge/bundled/dJe").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@luauforge/bundled/dJf").NavigationCommands else nil

local appPage = require("@luauforge/bundled/dJg").AppPage

local module4 = require("@luauforge/bundled/dJh")
local module5 = require("@luauforge/bundled/dJj")

local module6 = require("@luauforge/bundled/dJm")

local module7 = require("@luauforge/bundled/dJn")

local module8 = require("@luauforge/bundled/dJo")
local fFlagLuaAppDefaultHttpRetry = require("@luauforge/bundled/dJe").FFlagLuaAppDefaultHttpRetry

local config = module3.config
local v5 = {
	requestFunction = module3.requestFunctions.RequestInternal,
	maxRetryCount = 0
}

local v6 = if fFlagLuaAppDefaultHttpRetry then game:DefineFastInt(
	"ChallengeDialogEventReceiverHttpRetryCount",
	4
) else nil
v5.maxRetryCount = v6
local v7 = config(v5)

return module2.connect(function(p2, p3)
	return {}
end, function(callback)
	return {
		navigateToPage = function(p2, p3)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.sideways(navigationCommands.fromLegacyPage(p2), p3)
			end

			return callback(navigateSideways(p2, p3))
		end,
		fetchDialog = function(p2)
			return callback(module5(p2))
		end
	}
end)(function(data): nil
	local robloxEventReceiver = data.RobloxEventReceiver
	local v8 = 0
	local v9 = false

	local function fn()
		data.fetchDialog(v7):andThen(function(p2)
			local dialog = p2.dialogs[1]

			if dialog ~= nil then
				local challengeDialogExpired = dialog.isExpired and module4.ChallengeDialogExpired
					or module4.ChallengeDialogApproval
				data.navigateToPage({
					name = appPage.ChallengeDialogModalContainer,
					extraProps = {
						modalState = challengeDialogExpired,
						dialogItem = dialog
					}
				})
			end
		end):catch(function(p2) end):await()
	end

	module.useEffect(function()
		local v10 = {
			robloxEventReceiver:observeEvent("signalR", function(p2, p3, p4)
				if p2 == Enum.ConnectionState.Connected then
					if not module8() then
						fn()
					elseif p4 and p4.ChallengeDialogNotification then
						if v8 ~= p4.ChallengeDialogNotification and not v9 then
							fn()
						end

						v8 = p4.ChallengeDialogNotification
					end
				end
			end),
			robloxEventReceiver:observeEvent("ChallengeDialogNotification", function(p2)
				v8 = p2.SequenceNumber

				if not v9 then
					fn()
				end
			end),
			robloxEventReceiver:observeEvent("AppInput", function(p2, p3)
				if p3 == "Focused" then
					v9 = false

					local v11 = module6()

					for i = 1, module7() + 1 do
						task.delay(i * v11, fn)
					end
				else
					v9 = p3 == "Unfocused"
				end
			end)
		}

		return function()
			for k, v11 in pairs(v10) do
				v11:disconnect()
			end
		end
	end, {})

	return nil
end)
