local AcceptFriendRequestActions = require(script.AcceptFriendRequestActions)
local AddFriendActions = require(script.AddFriendActions)
local BlockActions = require(script.BlockActions)
local ChatAction = require(script.ChatAction)
local CommunityActions = require(script.CommunityActions)
local CurrencyTransferAction = require(script.CurrencyTransferAction)
local EditAliasAction = require(script.EditAliasAction)
local EditAppearanceActions = require(script.EditAppearanceActions)
local EditProfileAction = require(script.EditProfileAction)
local FollowActions = require(script.FollowActions)
local IgnoreFriendRequestAction = require(script.IgnoreFriendRequestAction)
local JoinExperienceAction = require(script.JoinExperienceAction)
local PendingFriendRequestAction = require(script.PendingFriendRequestAction)
local QrCodeAction = require(script.QrCodeAction)
local ReportAction = require(script.ReportAction)
local ShareProfileAction = require(script.ShareProfileAction)
local TrustedConnectionActions = require(script.TrustedConnectionActions)
local UnfriendAction = require(script.UnfriendAction)
local UnlockChatAction = require(script.UnlockChatAction)
local ViewAboutAction = require(script.ViewAboutAction)
local ViewPlatformProfileAction = require(script.ViewPlatformProfileAction)
local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)

local SupportedProfileTypes = require(script.SupportedProfileTypes)
local t1 = {}

local function withValidation(s1: string, p1) -- line: 54
	-- upvalues: SupportedProfileTypes (copy)
	return function(p2) -- line: 55
		-- upvalues: p1 (copy), s1 (copy), SupportedProfileTypes (copy)
		local v41 = p1(p2)

		if v41 ~= nil then
			assert(type(v41.onActivated) == "table", s1 .. " has onActivated as " .. type(v41.onActivated) .. ", expected table")

			for v42 in v41.onActivated do
				local v43 = SupportedProfileTypes[v42]

				assert(v43 and table.find(v43, s1), s1 .. " has onActivated for " .. tostring(v42) .. " but is missing from SupportedProfileTypes")
			end
		end

		return v41
	end
end

for _, v27 in {
	AcceptFriendRequestActions,
	AddFriendActions,
	BlockActions,
	ChatAction,
	CommunityActions,
	CurrencyTransferAction,
	EditAliasAction,
	EditAppearanceActions,
	EditProfileAction,
	FollowActions,
	IgnoreFriendRequestAction,
	JoinExperienceAction,
	PendingFriendRequestAction,
	QrCodeAction,
	ReportAction,
	ShareProfileAction,
	TrustedConnectionActions,
	UnfriendAction,
	UnlockChatAction,
	ViewAboutAction,
	ViewPlatformProfileAction
} do
	for v28, v29 in v27 do
		assert(t1[v28] == nil, "Duplicate ProfileAction key: " .. tostring(v28))
		t1[v28] = function(p3) -- line: 55
			-- upvalues: v29 (copy), v28 (copy), SupportedProfileTypes (copy)
			local v37 = v29(p3)

			if v37 ~= nil then
				assert(type(v37.onActivated) == "table", v28 .. " has onActivated as " .. type(v37.onActivated) .. ", expected table")

				for v38 in v37.onActivated do
					local v39 = SupportedProfileTypes[v38]

					assert(v39 and table.find(v39, v28), v28 .. " has onActivated for " .. tostring(v38) .. " but is missing from SupportedProfileTypes")
				end
			end

			return v37
		end
	end
end

for v30, v31 in SupportedProfileTypes do
	for _, v33 in v31 do
		assert(t1[v33] ~= nil, v33 .. " is listed in SupportedProfileTypes for " .. tostring(v30) .. " but has no matching factory")
	end
end

return t1
