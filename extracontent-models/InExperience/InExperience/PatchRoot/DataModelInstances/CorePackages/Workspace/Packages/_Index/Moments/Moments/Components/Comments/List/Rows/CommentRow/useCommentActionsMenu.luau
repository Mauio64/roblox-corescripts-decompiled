local parent = script:FindFirstAncestor("Moments").Parent

require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)

require(script.Parent.CommentRowView)

local useLocalization = Localization.Hooks.useLocalization

local v = {
	report = "Feature.Moments.Action.Report",
	block = "Feature.Moments.Action.Block",
	delete = "Feature.Moments.Action.Delete"
}

local function useCommentActionsMenu(data)
	local v2 = useLocalization(v)
	local report = v2.report
	local block = v2.block
	local delete = v2.delete

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
	local v3 = not data.isAuthoredByViewer

	if v3 then
		if authorUserId == nil then
			v3 = false
		else
			v3 = onReportComment ~= nil
		end
	end

	local v4 = not data.isAuthoredByViewer

	if v4 then
		if authorUserId == nil then
			v4 = false
		else
			v4 = onBlockCommentAuthor ~= nil
		end
	end

	local v5 = data.isAuthoredByViewer and onDeleteComment ~= nil

	local openMenu = React.useCallback(function()
		setState(commentId)
	end, { commentId })
	local closeMenu = React.useCallback(function()
		setState(nil)
	end, {})
	local toggleMenu = React.useCallback(function()
		setState(function(p: string?)
			return if p ~= commentId then commentId else nil
		end)
	end, { commentId })
	local onActivated = React.useCallback(function()
		setState(nil)

		if onReportComment ~= nil and authorUserId ~= nil then
			onReportComment(commentId, authorUserId)
		end
	end, { onReportComment, commentId, authorUserId })
	local onActivated2 = React.useCallback(function()
		setState(nil)

		if onBlockCommentAuthor ~= nil and authorUserId ~= nil then
			onBlockCommentAuthor(commentId, authorUserId)
		end
	end, { onBlockCommentAuthor, commentId, authorUserId })
	local onActivated3 = React.useCallback(function()
		setState(nil)
		setState2(commentId)
	end, { commentId })
	local onConfirm = React.useCallback(function()
		setState2(nil)

		if onDeleteComment ~= nil and state2 ~= nil then
			onDeleteComment(state2)
		end
	end, { onDeleteComment, state2 })
	local onCancel = React.useCallback(function()
		setState2(nil)
	end, {})

	return {
		items = React.useMemo(function()
			local v6 = {}

			if v3 then
				table.insert(v6, { id = "report", text = report, onActivated = onActivated })
			end

			if v4 then
				table.insert(v6, { id = "block", text = block, onActivated = onActivated2 })
			end

			if v5 then
				table.insert(v6, { id = "delete", text = delete, onActivated = onActivated3 })
			end

			return v6
		end, {
			v3,
			v4,
			v5,
			onActivated,
			onActivated2,
			onActivated3,
			report,
			block,
			delete
		}),
		isOpen = state == commentId,
		openMenu = openMenu,
		closeMenu = closeMenu,
		toggleMenu = toggleMenu,
		deleteConfirmation = v5 and state2 == commentId and {
			onConfirm = onConfirm,
			onCancel = onCancel
		} or nil
	}
end

return useCommentActionsMenu
