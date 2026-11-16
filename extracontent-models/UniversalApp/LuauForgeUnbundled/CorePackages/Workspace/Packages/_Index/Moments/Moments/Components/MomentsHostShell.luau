local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

local MomentsSessionContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext")
local MomentsHostContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")
local experienceDetailsSheet = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet").ExperienceDetailsSheet
local getExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/getExperienceDetailsSheetStore")
local ToastOverlay = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ToastOverlay")
local useIsTopMomentsShell = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsTopMomentsShell")
local FFlagMomentsOverlaysInTopShellOnly = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsOverlaysInTopShellOnly")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local v5 = if fFlagMomentsComments then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet") else nil
local FFlagMomentsCreatorAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsCreatorAnalytics")
local v6 = if FFlagMomentsCreatorAnalytics then require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights") else nil

local function closeSheets(p2)
	getExperienceDetailsSheetStore(false).close()

	if v5 ~= nil then
		local commentsSheetStore = v5.getCommentsSheetStore(false)

		if commentsSheetStore.getIsOpen(false) then
			commentsSheetStore.close(p2 == "popped" and "unmounted" or "navigation_hidden")
		end
	end

	if v6 ~= nil then
		v6.getPostInsightsPageStore(false).close()
	end
end

local function MomentsHostShell(props)
	local useMemo = React.useMemo
	local function fn()
		local v7 = {
			openProfile = props.openProfile,
			openOwnMoments = props.openOwnMoments,
			openMomentsFeedReport = props.openMomentsFeedReport,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}
		local v8 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
		v7.openAvatarLookTryOn = v8
		v7.openMomentCommentReport = props.openMomentCommentReport
		v7.openBlockUser = props.openBlockUser
		return v7
	end

	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v8 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
	local v9 = useMemo(fn, {
		openProfile,
		openOwnMoments,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v8
	})

	local v10 = not FFlagMomentsOverlaysInTopShellOnly or useIsTopMomentsShell(closeSheets)

	local createElement = React.createElement
	local provider = MomentsSessionContext.MomentsSessionContext.Provider
	local v11 = { value = props.sessionStore }

	local createElement2 = React.createElement
	local provider2 = MomentsHostContext.MomentsHostContext.Provider

	local createElement3 = React.createElement
	local fragment = React.Fragment

	local children = props.children
	local v16 = if v10 then React.createElement(experienceDetailsSheet) else nil
	local v17

	if fFlagMomentsComments and v5 ~= nil and v10 then
		v17 = React.createElement(v5.CommentsSheetContainer)
	end

	local v18

	if FFlagMomentsCreatorAnalytics and v6 ~= nil and v10 then
		v18 = React.createElement(v6.PostInsightsPageContainer)
	end

	local v19 = if v10 then React.createElement(ToastOverlay) else nil
	return createElement(provider, v11, {
		Host = createElement2(provider2, { value = v9 }, {
			Content = createElement3(fragment, nil, children, v16, v17, v18, v19)
		})
	})
end

return MomentsHostShell
