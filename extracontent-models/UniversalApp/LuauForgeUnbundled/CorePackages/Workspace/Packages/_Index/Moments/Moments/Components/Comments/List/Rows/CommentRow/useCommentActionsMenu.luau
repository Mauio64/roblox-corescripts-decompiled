require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/List/Rows/CommentRow/CommentRowView")

local useLocalization = Localization.Hooks.useLocalization

local v5 = {
	report = "Feature.Moments.Action.Report",
	block = "Feature.Moments.Action.Block",
	delete = "Feature.Moments.Action.Delete"
}

local function useCommentActionsMenu(data)
	local v6 = useLocalization(v5)
	local report = v6.report
	local block = v6.block
	local delete = v6.delete

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(nil)
	local commentId = data.commentId

	React.useLayoutEffect(function()
		setState(nil)
		setState2(nil)
	end, { commentId })
	local authorUserId = data.authorUserId
	local onReportComment = data.onReportComment
	local onBlockCommentAuthor = data.onBlockCommentAuthor
	local onDeleteComment = data.onDeleteComment
	local v7 = not data.isAuthoredByViewer

	if v7 then
		v7 = not (authorUserId == nil) and onReportComment ~= nil
	end

	local v8 = not data.isAuthoredByViewer

	if v8 then
		v8 = not (authorUserId == nil) and onBlockCommentAuthor ~= nil
	end

	local v9 = data.isAuthoredByViewer and onDeleteComment ~= nil

	local v10 = React.useCallback(function()
		setState(commentId)
	end, { commentId })
	local v11 = React.useCallback(function()
		setState(nil)
	end, {})
	local v12 = React.useCallback(function()
		setState(function(p2)
			if p2 == commentId then
				return nil
			end

			return commentId
		end)
	end, { commentId })
	local v13 = React.useCallback(function()
		setState(nil)

		if onReportComment ~= nil and authorUserId ~= nil then
			onReportComment(commentId, authorUserId)
		end
	end, { onReportComment, commentId, authorUserId })
	local v14 = React.useCallback(function()
		setState(nil)

		if onBlockCommentAuthor ~= nil and authorUserId ~= nil then
			onBlockCommentAuthor(commentId, authorUserId)
		end
	end, { onBlockCommentAuthor, commentId, authorUserId })
	local v15 = React.useCallback(function()
		setState(nil)
		setState2(commentId)
	end, { commentId })
	local v16 = React.useCallback(function()
		setState2(nil)

		if onDeleteComment ~= nil and state2 ~= nil then
			onDeleteComment(state2)
		end
	end, { onDeleteComment, state2 })
	local v17 = React.useCallback(function()
		setState2(nil)
	end, {})

	return {
		items = React.useMemo(function()
			local v18 = {}

			if v7 then
				table.insert(v18, { id = "report", text = report, onActivated = v13 })
			end

			if v8 then
				table.insert(v18, { id = "block", text = block, onActivated = v14 })
			end

			if v9 then
				table.insert(v18, { id = "delete", text = delete, onActivated = v15 })
			end

			return v18
		end, {
			v7,
			v8,
			v9,
			v13,
			v14,
			v15,
			report,
			block,
			delete
		}),
		isOpen = state == commentId,
		openMenu = v10,
		closeMenu = v11,
		toggleMenu = v12,
		deleteConfirmation = v9 and state2 == commentId and {
			onConfirm = v16,
			onCancel = v17
		} or nil
	}
end

return useCommentActionsMenu
