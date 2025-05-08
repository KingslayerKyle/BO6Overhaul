CoD.T10ButtonListItem = InheritFrom( LUI.UIElement )
CoD.T10ButtonListItem.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10ButtonListItem )
	self.id = "T10ButtonListItem"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 341.5 )
	self:setTopBottom( true, false, 0, 37 )
	self:makeFocusable()
	self:setHandleMouse( true )
	self.anyChildUsesUpdateState = true

	self.Background = LUI.UIImage.new()
	self.Background:setLeftRight( true, true, 0, 0 )
	self.Background:setTopBottom( true, true, 0, 0 )
	self.Background:setImage( RegisterImage( "ximage_bb278e338339881" ) )
	self:addElement( self.Background )

	self.OutlineT = LUI.UIImage.new()
	self.OutlineT:setLeftRight( true, true, 0, 0 )
	self.OutlineT:setTopBottom( true, false, 0, 0.5 )
	self.OutlineT:setImage( RegisterImage( "$white" ) )
	self.OutlineT:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.OutlineT )

	self.OutlineB = LUI.UIImage.new()
	self.OutlineB:setLeftRight( true, true, 0, 0 )
	self.OutlineB:setTopBottom( false, true, -0.5, 0 )
	self.OutlineB:setImage( RegisterImage( "$white" ) )
	self.OutlineB:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.OutlineB )

	self.OutlineL = LUI.UIImage.new()
	self.OutlineL:setLeftRight( true, false, 0, 0.5 )
	self.OutlineL:setTopBottom( true, true, 0, 0 )
	self.OutlineL:setImage( RegisterImage( "$white" ) )
	self.OutlineL:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.OutlineL )

	self.OutlineR = LUI.UIImage.new()
	self.OutlineR:setLeftRight( false, true, 0, -0.5 )
	self.OutlineR:setTopBottom( true, true, 0, 0 )
	self.OutlineR:setImage( RegisterImage( "$white" ) )
	self.OutlineR:setRGB( 0.5, 0.5, 0.5 )
	self:addElement( self.OutlineR )

	self.FocusBackground = LUI.UIImage.new()
	self.FocusBackground:setLeftRight( true, true, 0, 0 )
	self.FocusBackground:setTopBottom( true, true, 0, 0 )
	self.FocusBackground:setImage( RegisterImage( "ximage_b7c9030ee32123a" ) )
	self:addElement( self.FocusBackground )
	
	self.btnDisplayText = LUI.UIText.new()
	self.btnDisplayText:setLeftRight( true, true, -42.5, 0 )
	self.btnDisplayText:setTopBottom( true, true, 0 + 5, 0 - 5 )
	self.btnDisplayText:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.btnDisplayText:setRGB( 0.5, 0.5, 0.5 )
	self.btnDisplayText:setScale( 0.6 )
	self.btnDisplayText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.btnDisplayText:linkToElementModel( self, "displayText", true, function ( model ) 
		local displayText = Engine.GetModelValue( model )

		if displayText then
			self.btnDisplayText:setText( Engine.Localize( LocalizeToUpperString( displayText ) ) )
		end
	end )
	self:addElement( self.btnDisplayText )
	
	self.btnDisplayTextStroke = LUI.UIText.new()
	self.btnDisplayTextStroke:setLeftRight( true, true, -42.5, 0 )
	self.btnDisplayTextStroke:setTopBottom( true, true, 0 + 5, 0 - 5 )
	self.btnDisplayTextStroke:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.btnDisplayTextStroke:setRGB( 0.07, 0.07, 0.07 )
	self.btnDisplayTextStroke:setScale( 0.6 )
	self.btnDisplayTextStroke:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.btnDisplayTextStroke:linkToElementModel( self, "displayText", true, function ( model )
		local displayText = Engine.GetModelValue( model )

		if displayText then
			self.btnDisplayTextStroke:setText( Engine.Localize( LocalizeToUpperString( displayText ) ) )
		end
	end )
	self:addElement( self.btnDisplayTextStroke )
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 3 )

				self.FocusBackground:completeAnimation()
				self.FocusBackground:setAlpha( 0 )
				self.clipFinished( self.FocusBackground, {} )

				self.btnDisplayText:completeAnimation()
				self.btnDisplayText:setAlpha( 1 )
				self.clipFinished( self.btnDisplayText, {} )

				self.btnDisplayTextStroke:completeAnimation()
				self.btnDisplayTextStroke:setAlpha( 0 )
				self.clipFinished( self.btnDisplayTextStroke, {} )
			end,
			Focus = function ()
				self:setupElementClipCounter( 3 )

				self.FocusBackground:completeAnimation()
				self.FocusBackground:setAlpha( 1 )
				self.clipFinished( self.FocusBackground, {} )

				self.btnDisplayText:completeAnimation()
				self.btnDisplayText:setAlpha( 0 )
				self.clipFinished( self.btnDisplayText, {} )

				self.btnDisplayTextStroke:completeAnimation()
				self.btnDisplayTextStroke:setAlpha( 1 )
				self.clipFinished( self.btnDisplayTextStroke, {} )
			end,
			LoseFocus = function ()
				self:setupElementClipCounter( 2 )

				local btnDisplayTextFrame1 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 50, false, false, CoD.TweenType.Linear )
					end

					element:setAlpha( 1 )
					
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				self.btnDisplayText:completeAnimation()
				self.btnDisplayText:setAlpha( 0 )
				btnDisplayTextFrame1( self.btnDisplayText, {} )

				local btnDisplayTextStrokeFrame1 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 50, false, false, CoD.TweenType.Linear )
					end

					element:setAlpha( 0 )

					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				self.btnDisplayTextStroke:completeAnimation()
				self.btnDisplayTextStroke:setAlpha( 1 )
				btnDisplayTextStrokeFrame1( self.btnDisplayTextStroke, {} )
			end,
			GainFocus = function ()
				self:setupElementClipCounter( 2 )

				local btnDisplayTextFrame1 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 50, false, false, CoD.TweenType.Linear )
					end

					element:setAlpha( 0 )

					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				self.btnDisplayText:completeAnimation()
				self.btnDisplayText:setAlpha( 1 )
				btnDisplayTextFrame1( self.btnDisplayText, {} )

				local btnDisplayTextStrokeFrame1 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 50, false, false, CoD.TweenType.Linear )
					end

					element:setAlpha( 1 )

					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end
				
				self.btnDisplayTextStroke:completeAnimation()
				self.btnDisplayTextStroke:setAlpha( 0 )
				btnDisplayTextStrokeFrame1( self.btnDisplayTextStroke, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Background:close()
		element.OutlineT:close()
		element.OutlineB:close()
		element.OutlineL:close()
		element.OutlineR:close()
		element.FocusBackground:close()
		element.btnDisplayText:close()
		element.btnDisplayTextStroke:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
