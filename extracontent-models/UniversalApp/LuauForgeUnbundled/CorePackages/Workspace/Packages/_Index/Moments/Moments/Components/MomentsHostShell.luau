local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

local MomentsSessionContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/MomentsSessionContext")
local MomentsHostContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/MomentsHostContext")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetMomentsStore/createMomentsStore")
local experienceDetailsSheet = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet").ExperienceDetailsSheet
local getExperienceDetailsSheetStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/ExperienceDetailsSheet/Sheet/getExperienceDetailsSheetStore")
local ToastOverlay = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/ToastOverlay")

local function getPostStatusCardContainer()
	return require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusCard/PostStatusCardContainer")
end

local useIsTopMomentsShell = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useIsTopMomentsShell")
local fFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagMomentsOverlaysInTopShellOnly = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsOverlaysInTopShellOnly")
local fFlagMomentsComments = SharedFlags.FFlagMomentsComments
local fFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local fFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback
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

local function ignoreTopShellChange(p2) end

local function MomentsHostShell(props)
	local v7

	if FFlagMomentsOverlaysInTopShellOnly or fFlagProfileRenderAvatarMoments then
		local v9 = if FFlagMomentsOverlaysInTopShellOnly then closeSheets else ignoreTopShellChange
		v7 = useIsTopMomentsShell(v9)
	else
		v7 = true
	end

	local useMemo = React.useMemo
	local function fn()
		local v8 = {
			isTopShell = if fFlagProfileRenderAvatarMoments then v7 else nil,
			openProfile = props.openProfile,
			openOwnMoments = props.openOwnMoments,
			openAvatarMomentsCreation = 0,
			openMomentsFeedReport = 0,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}

		local v10 = if fFlagMomentsCreateAvatarPosts then props.openAvatarMomentsCreation else nil
		v8.openAvatarMomentsCreation = v10

		v8.openMomentsFeedReport = props.openMomentsFeedReport
		local v11 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
		v8.openAvatarLookTryOn = v11
		v8.openMomentCommentReport = props.openMomentCommentReport
		v8.openBlockUser = props.openBlockUser
		return v8
	end

	local v9 = if fFlagProfileRenderAvatarMoments then v7 else nil
	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openAvatarMomentsCreation = if fFlagMomentsCreateAvatarPosts then props.openAvatarMomentsCreation else nil
	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v10 = if fFlagMomentsAvatarLookTryOn then props.openAvatarLookTryOn else nil
	local v11 = useMemo(fn, {
		v9,
		openProfile,
		openOwnMoments,
		openAvatarMomentsCreation,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v10
	})

	local v12 = not FFlagMomentsOverlaysInTopShellOnly or v7

	local createElement = React.createElement
	local provider = MomentsSessionContext.MomentsSessionContext.Provider
	local v13 = { value = props.sessionStore }

	local createElement2 = React.createElement
	local provider2 = MomentsHostContext.MomentsHostContext.Provider

	local createElement3 = React.createElement
	local fragment = React.Fragment

	local children = props.children
	local v18 = if v12 then React.createElement(experienceDetailsSheet) else nil
	local v19

	if fFlagMomentsComments and v5 ~= nil and v12 then
		v19 = React.createElement(v5.CommentsSheetContainer)
	end

	local v20

	if FFlagMomentsCreatorAnalytics and v6 ~= nil and v12 then
		v20 = React.createElement(v6.PostInsightsPageContainer)
	end

	local v21

	if fFlagMomentsPostFeedback and v12 then
		v21 = React.createElement(getPostStatusCardContainer())
	end

	local v22 = if v12 then React.createElement(ToastOverlay) else nil
	return createElement(provider, v13, {
		Host = createElement2(provider2, { value = v11 }, {
			Content = createElement3(fragment, nil, children, v18, v19, v20, v21, v22)
		})
	})
end

return MomentsHostShell
