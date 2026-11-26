return {
	resolveCommentsNetwork = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Comments/resolveCommentsNetwork"),
	createMomentsCommentsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createMomentsCommentsStore"),
	fetchMomentComments = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchMomentComments"),
	fetchMomentComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchMomentComment"),
	postMomentComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/postMomentComment"),
	deleteMomentComment = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/deleteMomentComment"),
	putMomentCommentReaction = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/putMomentCommentReaction"),
	deleteMomentCommentReaction = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/deleteMomentCommentReaction"),
	extractCommentsFromPage = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/extractCommentsFromPage"),
	parseCommentsError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Util/parseCommentsError")
}
