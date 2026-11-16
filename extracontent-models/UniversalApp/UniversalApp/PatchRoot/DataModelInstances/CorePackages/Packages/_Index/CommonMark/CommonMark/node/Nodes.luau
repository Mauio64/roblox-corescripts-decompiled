local CommonMark = script:FindFirstAncestor("CommonMark")
local BlockQuote = require(CommonMark.node.BlockQuote)
local BulletList = require(CommonMark.node.BulletList)
local Code = require(CommonMark.node.Code)
require(CommonMark.node.CustomBlock)
require(CommonMark.node.CustomNode)
require(CommonMark.node.Delimited)
local Document = require(CommonMark.node.Document)
local Emphasis = require(CommonMark.node.Emphasis)
local FencedCodeBlock = require(CommonMark.node.FencedCodeBlock)
local HardLineBreak = require(CommonMark.node.HardLineBreak)
local Heading = require(CommonMark.node.Heading)
local HtmlBlock = require(CommonMark.node.HtmlBlock)
local HtmlInline = require(CommonMark.node.HtmlInline)
local Image = require(CommonMark.node.Image)
local IndentedCodeBlock = require(CommonMark.node.IndentedCodeBlock)
local Link = require(CommonMark.node.Link)
local LinkReferenceDefinition = require(CommonMark.node.LinkReferenceDefinition)
require(CommonMark.node.ListBlock)
local ListItem = require(CommonMark.node.ListItem)
require(CommonMark.node.Node)
return {
	["BlockQuote"] = BlockQuote,
	BulletList = BulletList,
	Code = Code,
	Document = Document,
	Emphasis = Emphasis,
	FencedCodeBlock = FencedCodeBlock,
	HardLineBreak = HardLineBreak,
	Heading = Heading,
	HtmlBlock = HtmlBlock,
	HtmlInline = HtmlInline,
	Image = Image,
	IndentedCodeBlock = IndentedCodeBlock,
	Link = Link,
	LinkReferenceDefinition = LinkReferenceDefinition,
	ListItem = ListItem,
	OrderedList = require(CommonMark.node.OrderedList),
	Paragraph = require(CommonMark.node.Paragraph),
	SoftLineBreak = require(CommonMark.node.SoftLineBreak),
	StrongEmphasis = require(CommonMark.node.StrongEmphasis),
	Text = require(CommonMark.node.Text),
	ThematicBreak = require(CommonMark.node.ThematicBreak),
	between = function(object, p)
		local v = object:getNext()
		return function()
			if v == nil or v == p then
				return nil
			end

			local v2 = v
			v = v2:getNext()
			return v2
		end
	end
}
