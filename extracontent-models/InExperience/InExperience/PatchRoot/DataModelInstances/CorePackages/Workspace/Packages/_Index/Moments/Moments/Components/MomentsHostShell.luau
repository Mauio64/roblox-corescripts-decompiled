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
local useIsTopMomentsShell = require(Moments.Hooks.useIsTopMomentsShell)
local FFlagMomentsOverlaysInTopShellOnly = require(Moments.Flags.FFlagMomentsOverlaysInTopShellOnly)
local FFlagMomentsComments = SharedFlags.FFlagMomentsComments
local FFlagMomentsAvatarLookTryOn = SharedFlags.FFlagMomentsAvatarLookTryOn
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

local function MomentsHostShell(props)
	local useMemo = React.useMemo
	local function fn()
		local v = {
			openProfile = props.openProfile,
			openOwnMoments = props.openOwnMoments,
			openMomentsFeedReport = props.openMomentsFeedReport,
			openAvatarLookTryOn = 0,
			openMomentCommentReport = 0,
			openBlockUser = 0
		}
		local openAvatarLookTryOn

		if FFlagMomentsAvatarLookTryOn then
			openAvatarLookTryOn = props.openAvatarLookTryOn
		end

		v.openAvatarLookTryOn = openAvatarLookTryOn
		v.openMomentCommentReport = props.openMomentCommentReport
		v.openBlockUser = props.openBlockUser
		return v
	end

	local openProfile = props.openProfile
	local openOwnMoments = props.openOwnMoments
	local openMomentsFeedReport = props.openMomentsFeedReport
	local openMomentCommentReport = props.openMomentCommentReport
	local openBlockUser = props.openBlockUser
	local v

	if FFlagMomentsAvatarLookTryOn then
		v = props.openAvatarLookTryOn
	end

	local v2 = useMemo(fn, {
		openProfile,
		openOwnMoments,
		openMomentsFeedReport,
		openMomentCommentReport,
		openBlockUser,
		v
	})

	local v3 = not FFlagMomentsOverlaysInTopShellOnly or useIsTopMomentsShell(closeSheets)

	local createElement = React.createElement
	local provider = MomentsSessionContext.MomentsSessionContext.Provider
	local v4 = { value = props.sessionStore }

	local createElement2 = React.createElement
	local provider2 = MomentsHostContext.MomentsHostContext.Provider

	local createElement3 = React.createElement
	local fragment = React.Fragment

	local children = props.children
	local v5

	if v3 then
		v5 = React.createElement(experienceDetailsSheet)
	end

	local v6

	if FFlagMomentsComments and Sheet ~= nil and v3 then
		v6 = React.createElement(Sheet.CommentsSheetContainer)
	end

	local v7

	if FFlagMomentsCreatorAnalytics and PostInsights ~= nil and v3 then
		v7 = React.createElement(PostInsights.PostInsightsPageContainer)
	end

	local v8

	if v3 then
		v8 = React.createElement(ToastOverlay)
	end

	return createElement(provider, v4, {
		Host = createElement2(provider2, { value = v2 }, {
			Content = createElement3(fragment, nil, children, v5, v6, v7, v8)
		})
	})
end

return MomentsHostShell
