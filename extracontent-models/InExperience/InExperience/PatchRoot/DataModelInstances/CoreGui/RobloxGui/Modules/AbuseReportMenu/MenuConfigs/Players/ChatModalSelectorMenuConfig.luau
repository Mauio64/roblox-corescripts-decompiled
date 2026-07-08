local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local UserService = game:GetService("UserService")
local getMessageText = require(CorePackages.Workspace.Packages.ChatLineReporting).Helpers.getMessageText
local Constants = require(AbuseReportMenu.Components.Constants)

require(AbuseReportMenu.Components.Types)

return {
	componentType = "chatModalSelector",
	fieldLabel = "WhichChat",
	componentName = "ChatSelector",
	getIsVisible = function(p1) -- line: 19
		-- upvalues: Constants (copy)
		return p1.methodOfAbuse == Constants.AbuseMethods.TextChat
	end,
	getSelectedValue = function(p2) -- line: 27
		-- upvalues: getMessageText (copy)
		return p2.selectedMessage and getMessageText(p2.selectedMessage.useTranslation, p2.selectedMessage.translation, p2.selectedMessage.text) or nil
	end,
	onUpdateSelectedOption = function(p3, t1: {[any]: any}, p4, p5, p6) -- line: 42
		-- upvalues: Constants (copy), Players (copy), UserService (copy)
		p6.analyticsDispatch({
			type = Constants.AnalyticsActions.IncrementChatLineChanged
		})
		p5({
			type = Constants.PlayerMenuActions.UpdatedSelectedChatAndOrderedMessages,
			orderedMessages = t1,
			selectedMessage = p3
		})

		if p4.allegedAbuserId ~= nil then
			if p3 == nil or p3.userId == nil then
				p5({
					abuseId = nil,
					abuser = nil,
					type = Constants.PlayerMenuActions.UpdateAbuser
				})

				return
			end

			local num = tonumber(p3.userId)

			if num ~= nil then
				task.defer(function() -- line: 73
					-- upvalues: Players (copy), num (copy), UserService (copy), p5 (copy), Constants (copy), p3 (copy)
					local PlayerByUserId = Players:GetPlayerByUserId(num)

					if PlayerByUserId == nil then
						local ok, result = pcall(function() -- line: 80
							-- upvalues: UserService (copy), num (copy)
							return UserService:GetUserInfosByUserIdsAsync({ num })
						end)

						if ok and result and result[1] then
							PlayerByUserId = {
								Name = result[1].Username,
								DisplayName = result[1].DisplayName
							}
						end
					end

					if PlayerByUserId ~= nil then
						p5({
							type = Constants.PlayerMenuActions.UpdateAbuser,
							abuseId = p3.userId,
							abuser = PlayerByUserId
						})
					end
				end)
			end
		end
	end
}
