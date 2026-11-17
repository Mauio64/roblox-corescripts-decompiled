local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local MomentsSessionContext = require(Moments.Stores.GetMomentsStore.MomentsSessionContext)
local MomentsHostContext = require(Moments.MomentsHostContext)
require(Moments.Stores.GetMomentsStore.createMomentsStore)
local ExperienceDetailsSheet = require(Moments.ExperienceDetailsSheet)
local experienceDetailsSheet = ExperienceDetailsSheet.ExperienceDetailsSheet
local getExperienceDetailsSheetStore = require(Moments.ExperienceDetailsSheet.Sheet.getExperienceDetailsSheetStore)
local ToastOverlay = require(Moments.Components.ToastOverlay)

local function getPostStatusCardContainer()
	return require(Moments.Components.PostFeedback.PostStatusCard.PostStatusCardContainer)
end

local useIsTopMomentsShell = require(Moments.Hooks.useIsTopMomentsShell)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts
local FFlagMomentsOverlaysInTopShellOnly = require(Moments.Flags.FFlagMomentsOverlaysInTopShellOnly)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
local FFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local FFlagMomentsPostFeedback = SharedFlags.FFlagMomentsPostFeedback
local Sheet

if FFlagMomentsComments then
	Sheet = require(Moments.Components.Comments.Sheet)
else
	Sheet = nil
end

local FFlagMomentsCreatorAnalytics = require(Moments.Flags.FFlagMomentsCreatorAnalytics)
local PostInsights

if FFlagMomentsCreatorAnalytics then
	PostInsights = require(Moments.Components.PostInsights)
else
	PostInsights = nil
end

local function closeSheets(p)
	getExperienceDetailsSheetStore(false).close()

	if Sheet ~= nil then
		local commentsSheetStore = Sheet.getCommentsSheetStore(false)

		if commentsSheetStore.getIsOpen(false) then
			commentsSheetStore.close(p == "popped" and "unmounted" or "navigation_hidden")
		end
	end

	if PostInsights ~= nil then
		PostInsights.getPostInsightsPageStore(false).close()
	end
end

local function ignoreTopShellChange(_) end

local function MomentsHostShell(props)
	local v

	if FFlagMomentsOverlaysInTopShellOnly or FFlagProfileRenderAvatarMoments then
		local v2

		if FFlagMomentsOverlaysInTopShellOnly then
			v2 = closeSheets
		else
			v2 = ignoreTopShellChange
		end

		v = useIsTopMomentsShell(v2)
	else
		v = true
	end

	local useMemo = React.useMemo
	local function fn()
		local isTopShell

		if FFlagProfileRenderAvatarMoments then
			isTopShell = v
		end

		local v2 = {
			isTopShell = isTopShell,
			openProfile = props.openProfile,
			openOwnMoments = props.openOwnMoments,
			openAvatarMomentsCreation = 0,
			openMomentsFeedReport = 0,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}
		local openAvatarMomentsCreation

		if FFlagMomentsCreateAvatarPosts then
			openAvatarMomentsCreation = props.openAvatarMomentsCreation
		end

		v2.openAvatarMomentsCreation = openAvatarMomentsCreation

		v2.openMomentsFeedReport = props.openMomentsFeedReport
		local openAvatarLookTryOn

		if FFlagMomentsAvatarLookTryOn then
			openAvatarLookTryOn = props.openAvatarLookTryOn
		end

		v2.openAvatarLookTryOn = openAvatarLookTryOn
		v2.openMomentCommentReport = props.openMomentCommentReport
		v2.openBlockUser = props.openBlockUser
		return v2
	end

	local v2

	if FFlagProfileRenderAvatarMoments then
		v2 = v
	end

	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openAvatarMomentsCreation

	if FFlagMomentsCreateAvatarPosts then
		openAvatarMomentsCreation = props.openAvatarMomentsCreation
	end

	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v3

	if FFlagMomentsAvatarLookTryOn then
		v3 = props.openAvatarLookTryOn
	end

	local v4 = useMemo(fn, {
		v2,
		openProfile,
		openOwnMoments,
		openAvatarMomentsCreation,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v3
	})

	local v5 = not FFlagMomentsOverlaysInTopShellOnly or v

	local createElement = React.createElement
	local provider = MomentsSessionContext.MomentsSessionContext.Provider
	local v6 = { value = props.sessionStore }

	local createElement2 = React.createElement
	local provider2 = MomentsHostContext.MomentsHostContext.Provider

	local createElement3 = React.createElement
	local fragment = React.Fragment

	local children = props.children
	local v7

	if v5 then
		v7 = React.createElement(experienceDetailsSheet)
	end

	local v8

	if FFlagMomentsComments and Sheet ~= nil and v5 then
		v8 = React.createElement(Sheet.CommentsSheetContainer)
	end

	local v9

	if FFlagMomentsCreatorAnalytics and PostInsights ~= nil and v5 then
		v9 = React.createElement(PostInsights.PostInsightsPageContainer)
	end

	local v10

	if FFlagMomentsPostFeedback and v5 then
		v10 = React.createElement(getPostStatusCardContainer())
	end

	local v11

	if v5 then
		v11 = React.createElement(ToastOverlay)
	end

	return createElement(provider, v6, {
		Host = createElement2(provider2, { value = v4 }, {
			Content = createElement3(fragment, nil, children, v7, v8, v9, v10, v11)
		})
	})
end

return MomentsHostShell
