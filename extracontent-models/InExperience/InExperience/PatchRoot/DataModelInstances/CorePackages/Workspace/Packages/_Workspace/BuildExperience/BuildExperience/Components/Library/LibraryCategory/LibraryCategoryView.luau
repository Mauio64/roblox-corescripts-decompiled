local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local LibraryGridView = require(script.Parent.LibraryGridView)
require(script.Parent.Parent.LibraryTypes)

local Text = Foundation.Text
local View = Foundation.View

local function LibraryCategoryView(props)
	local content

	if props.status == "Loading" or props.status == "NotReady" then
		content = React.createElement(View, {
			tag = "size-full",
			testId = "Library.Category.Skeleton"
		}, {
			Grid = React.createElement(LibraryGridView, {
				items = {},
				hasMore = false,
				isLoading = true,
				onLoadMore = function() end
			})
		})
	elseif #props.items == 0 then
		content = React.createElement(Text, {
			Text = props.strings.empty,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted"
		})
	else
		content = React.createElement(View, { tag = "col gap-medium size-full" }, {
			GridContainer = React.createElement(View, { LayoutOrder = 1, tag = "fill size-full-0" }, {
				Grid = React.createElement(LibraryGridView, {
					items = props.items,
					hasMore = props.hasMore,
					onLoadMore = props.onLoadMore
				})
			})
		})
	end

	local element = React.createElement(View, { tag = "col size-full padding-x-medium" }, {
		Body = React.createElement(View, { tag = "fill size-full-0" }, { Content = content })
	})

	return React.createElement(View, { tag = "col size-full", testId = "Library.CategoryPage" }, {
		Content = React.createElement(View, { tag = "fill size-full-0" }, { Body = element })
	})
end

return LibraryCategoryView
