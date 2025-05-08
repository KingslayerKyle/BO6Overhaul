CoD.T10ScoreboardInventory = InheritFrom( LUI.UIElement )
CoD.T10ScoreboardInventory.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10ScoreboardInventory )
	self.id = "T10ScoreboardInventory"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.HeaderBG1 = LUI.UIImage.new()
	self.HeaderBG1:setLeftRight( false, false, -193.5, 193.5 )
	self.HeaderBG1:setTopBottom( true, false, 84.5, 108 )
	self.HeaderBG1:setImage( RegisterImage( "ximage_38b2312e500451c" ) )
	self.HeaderBG1:setRGB( 0.1, 0.1, 0.1 )
	self:addElement( self.HeaderBG1 )

	self.HeaderBG2 = LUI.UIImage.new()
	self.HeaderBG2:setLeftRight( false, false, -193.5, 193.5 )
	self.HeaderBG2:setTopBottom( true, false, 84.5, 108 )
	self.HeaderBG2:setImage( RegisterImage( "ximage_38b2312e500451c" ) )
	self:addElement( self.HeaderBG2 )

	self.HeaderText = LUI.UIText.new()
	self.HeaderText:setLeftRight( false, false, -193.5, 193.5 )
	self.HeaderText:setTopBottom( true, false, 72.5, 120 )
	self.HeaderText:setText( Engine.Localize( "QUEST ITEMS" ) )
	self.HeaderText:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.HeaderText:setRGB( 0.85, 0.79, 0.70 )
	self.HeaderText:setScale( 0.5 )
	self.HeaderText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.HeaderText )

	self.ItemsBG1 = LUI.UIImage.new()
	self.ItemsBG1:setLeftRight( false, false, -193.5, 193.5 )
	self.ItemsBG1:setTopBottom( true, false, 108, 180.5 )
	self.ItemsBG1:setImage( RegisterImage( "$white" ) )
	self.ItemsBG1:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.ItemsBG1 )

	self.ItemsBG2 = LUI.UIImage.new()
	self.ItemsBG2:setLeftRight( false, false, -193.5, 193.5 )
	self.ItemsBG2:setTopBottom( true, false, 108, 180.5 )
	self.ItemsBG2:setImage( RegisterImage( "ximage_1b369af8242a1bc" ) )
	self:addElement( self.ItemsBG2 )

	self.Item1Text = LUI.UIText.new()
	self.Item1Text:setLeftRight( true, false, 454 - 100, 503 + 100 )
	self.Item1Text:setTopBottom( true, false, 106, 129 )
	self.Item1Text:setText( Engine.Localize( "QUEST ITEM 1" ) )
	self.Item1Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item1Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item1Text:setScale( 0.5 )
	self.Item1Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item1Text )

	self.Item1BG = LUI.UIImage.new()
	self.Item1BG:setLeftRight( true, false, 454, 503 )
	self.Item1BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item1BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item1BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item1BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item1BG )

	self.Item2Text = LUI.UIText.new()
	self.Item2Text:setLeftRight( true, false, 524 - 100, 573 + 100 )
	self.Item2Text:setTopBottom( true, false, 106, 129 )
	self.Item2Text:setText( Engine.Localize( "QUEST ITEM 2" ) )
	self.Item2Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item2Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item2Text:setScale( 0.5 )
	self.Item2Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item2Text )

	self.Item2BG = LUI.UIImage.new()
	self.Item2BG:setLeftRight( true, false, 524, 573 )
	self.Item2BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item2BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item2BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item2BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item2BG )

	self.Item3Text = LUI.UIText.new()
	self.Item3Text:setLeftRight( true, false, 594 - 100, 643 + 100 )
	self.Item3Text:setTopBottom( true, false, 106, 129 )
	self.Item3Text:setText( Engine.Localize( "QUEST ITEM 3" ) )
	self.Item3Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item3Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item3Text:setScale( 0.5 )
	self.Item3Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item3Text )

	self.Item3BG = LUI.UIImage.new()
	self.Item3BG:setLeftRight( true, false, 594, 643 )
	self.Item3BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item3BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item3BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item3BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item3BG )

	self.Item4Text = LUI.UIText.new()
	self.Item4Text:setLeftRight( true, false, 650.5 - 100, 699.5 + 100 )
	self.Item4Text:setTopBottom( true, false, 106, 129 )
	self.Item4Text:setText( Engine.Localize( "QUEST ITEM 4" ) )
	self.Item4Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item4Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item4Text:setScale( 0.5 )
	self.Item4Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item4Text )

	self.Item4BG = LUI.UIImage.new()
	self.Item4BG:setLeftRight( true, false, 650.5, 699.5 )
	self.Item4BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item4BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item4BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item4BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item4BG )

	self.Item5Text = LUI.UIText.new()
	self.Item5Text:setLeftRight( true, false, 707 - 100, 756 + 100 )
	self.Item5Text:setTopBottom( true, false, 106, 129 )
	self.Item5Text:setText( Engine.Localize( "QUEST ITEM 5" ) )
	self.Item5Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item5Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item5Text:setScale( 0.5 )
	self.Item5Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item5Text )

	self.Item5BG = LUI.UIImage.new()
	self.Item5BG:setLeftRight( true, false, 707, 756 )
	self.Item5BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item5BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item5BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item5BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item5BG )

	self.Item6Text = LUI.UIText.new()
	self.Item6Text:setLeftRight( true, false, 777 - 100, 826 + 100 )
	self.Item6Text:setTopBottom( true, false, 106, 129 )
	self.Item6Text:setText( Engine.Localize( "QUEST ITEM 6" ) )
	self.Item6Text:setTTF( "fonts/kairos_sans_w1g_cn_medium.ttf" )
	self.Item6Text:setRGB( 0.85, 0.79, 0.70 )
	self.Item6Text:setScale( 0.5 )
	self.Item6Text:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self:addElement( self.Item6Text )

	self.Item6BG = LUI.UIImage.new()
	self.Item6BG:setLeftRight( true, false, 777, 826 )
	self.Item6BG:setTopBottom( true, false, 124.5, 173.5 )
	self.Item6BG:setImage( RegisterImage( "ximage_2ac7bde1799b41e" ) )
	self.Item6BG:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_feather_edges" ) )
	self.Item6BG:setShaderVector( 0, 0.02, 0.02, 0.02, 0.02 )
	self:addElement( self.Item6BG )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 17 )

				self.HeaderBG1:completeAnimation()
				self.HeaderBG1:setAlpha( 1 )
				self.clipFinished( self.HeaderBG1, {} )
				
				self.HeaderBG2:completeAnimation()
				self.HeaderBG2:setAlpha( 1 )
				self.clipFinished( self.HeaderBG2, {} )
				
				self.HeaderText:completeAnimation()
				self.HeaderText:setAlpha( 1 )
				self.clipFinished( self.HeaderText, {} )
				
				self.ItemsBG1:completeAnimation()
				self.ItemsBG1:setAlpha( 1 )
				self.clipFinished( self.ItemsBG1, {} )
				
				self.ItemsBG2:completeAnimation()
				self.ItemsBG2:setAlpha( 1 )
				self.clipFinished( self.ItemsBG2, {} )
				
				self.Item1Text:completeAnimation()
				self.Item1Text:setAlpha( 1 )
				self.clipFinished( self.Item1Text, {} )
				
				self.Item1BG:completeAnimation()
				self.Item1BG:setAlpha( 1 )
				self.clipFinished( self.Item1BG, {} )
				
				self.Item2Text:completeAnimation()
				self.Item2Text:setAlpha( 1 )
				self.clipFinished( self.Item2Text, {} )
				
				self.Item2BG:completeAnimation()
				self.Item2BG:setAlpha( 1 )
				self.clipFinished( self.Item2BG, {} )
				
				self.Item3Text:completeAnimation()
				self.Item3Text:setAlpha( 1 )
				self.clipFinished( self.Item3Text, {} )
				
				self.Item3BG:completeAnimation()
				self.Item3BG:setAlpha( 1 )
				self.clipFinished( self.Item3BG, {} )
				
				self.Item4Text:completeAnimation()
				self.Item4Text:setAlpha( 1 )
				self.clipFinished( self.Item4Text, {} )
				
				self.Item4BG:completeAnimation()
				self.Item4BG:setAlpha( 1 )
				self.clipFinished( self.Item4BG, {} )
				
				self.Item5Text:completeAnimation()
				self.Item5Text:setAlpha( 1 )
				self.clipFinished( self.Item5Text, {} )
				
				self.Item5BG:completeAnimation()
				self.Item5BG:setAlpha( 1 )
				self.clipFinished( self.Item5BG, {} )
				
				self.Item6Text:completeAnimation()
				self.Item6Text:setAlpha( 1 )
				self.clipFinished( self.Item6Text, {} )
				
				self.Item6BG:completeAnimation()
				self.Item6BG:setAlpha( 1 )
				self.clipFinished( self.Item6BG, {} )
			end
		},
		Hidden = {
			DefaultClip = function ()
				self:setupElementClipCounter( 17 )

				self.HeaderBG1:completeAnimation()
				self.HeaderBG1:setAlpha( 0 )
				self.clipFinished( self.HeaderBG1, {} )
				
				self.HeaderBG2:completeAnimation()
				self.HeaderBG2:setAlpha( 0 )
				self.clipFinished( self.HeaderBG2, {} )
				
				self.HeaderText:completeAnimation()
				self.HeaderText:setAlpha( 0 )
				self.clipFinished( self.HeaderText, {} )
				
				self.ItemsBG1:completeAnimation()
				self.ItemsBG1:setAlpha( 0 )
				self.clipFinished( self.ItemsBG1, {} )
				
				self.ItemsBG2:completeAnimation()
				self.ItemsBG2:setAlpha( 0 )
				self.clipFinished( self.ItemsBG2, {} )
				
				self.Item1Text:completeAnimation()
				self.Item1Text:setAlpha( 0 )
				self.clipFinished( self.Item1Text, {} )
				
				self.Item1BG:completeAnimation()
				self.Item1BG:setAlpha( 0 )
				self.clipFinished( self.Item1BG, {} )
				
				self.Item2Text:completeAnimation()
				self.Item2Text:setAlpha( 0 )
				self.clipFinished( self.Item2Text, {} )
				
				self.Item2BG:completeAnimation()
				self.Item2BG:setAlpha( 0 )
				self.clipFinished( self.Item2BG, {} )
				
				self.Item3Text:completeAnimation()
				self.Item3Text:setAlpha( 0 )
				self.clipFinished( self.Item3Text, {} )
				
				self.Item3BG:completeAnimation()
				self.Item3BG:setAlpha( 0 )
				self.clipFinished( self.Item3BG, {} )
				
				self.Item4Text:completeAnimation()
				self.Item4Text:setAlpha( 0 )
				self.clipFinished( self.Item4Text, {} )
				
				self.Item4BG:completeAnimation()
				self.Item4BG:setAlpha( 0 )
				self.clipFinished( self.Item4BG, {} )
				
				self.Item5Text:completeAnimation()
				self.Item5Text:setAlpha( 0 )
				self.clipFinished( self.Item5Text, {} )
				
				self.Item5BG:completeAnimation()
				self.Item5BG:setAlpha( 0 )
				self.clipFinished( self.Item5BG, {} )
				
				self.Item6Text:completeAnimation()
				self.Item6Text:setAlpha( 0 )
				self.clipFinished( self.Item6Text, {} )
				
				self.Item6BG:completeAnimation()
				self.Item6BG:setAlpha( 0 )
				self.clipFinished( self.Item6BG, {} )
			end
		}
	}
	
	self:mergeStateConditions( {
		{
			stateName = "Hidden",
			condition = function ( menu, element, event )
				return CoD.InventoryDisabled == true
			end
		}
	} )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.HeaderBG1:close()
		element.HeaderBG2:close()
		element.HeaderText:close()
		element.ItemsBG1:close()
		element.ItemsBG2:close()
		element.Item1Text:close()
		element.Item1BG:close()
		element.Item2Text:close()
		element.Item2BG:close()
		element.Item3Text:close()
		element.Item3BG:close()
		element.Item4Text:close()
		element.Item4BG:close()
		element.Item5Text:close()
		element.Item5BG:close()
		element.Item6Text:close()
		element.Item6BG:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
