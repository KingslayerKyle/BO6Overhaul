require( "ui.uieditor.widgets.HUD.T10PopupWidget.T10PopupScoreText" )

local SetCriticalRGB = function ( element, eventName )
	if eventName:find( "Critical" ) then
		element:setRGB( 0.92, 0.94, 0.17 )
	else
		element:setRGB( 1, 1, 1 )
	end
end

local PostLoadFunc = function ( self, controller, menu )
	self:subscribeToGlobalModel( controller, "PerController", "scriptNotify", function ( model )
		local event = Engine.GetModelValue( model )

		if event == "score_event" then
			local scriptNotifyData = CoD.GetScriptNotifyData( model )
			local name = Engine.Localize( Engine.GetIString( scriptNotifyData[1], "CS_LOCALIZED_STRINGS" ) )
			local score = scriptNotifyData[2]

			if name ~= nil and score ~= nil and type( score ) == "number" then
				-- Set total score
				local totalText = self.total:getText()
				if totalText == nil or totalText == "" then
					totalText = "0"
				end
				local total = tonumber( totalText ) or 0
				total = total + score
				self.total:setText( tostring( total ) )

				-- Shift down existing texts
				for index = 5, 2, -1 do
					local prevName = self["text" .. index - 1].name:getText() or ""
					local prevScore = self["text" .. index - 1].score:getText() or ""
					self["text" .. index].name:setText( tostring( prevName ) )
					self["text" .. index].score:setText( tostring( prevScore ) )
					SetCriticalRGB( self["text" .. index].name, tostring( prevName ) )
				end

				-- Set new text
				self.text1.name:setText( tostring( name ) )
				self.text1.score:setText( "+" .. tostring( score ) )
				SetCriticalRGB( self.text1.name, tostring( name ) )

				-- Fade out
				PlayClip( self, "PopupAnim", controller )

				-- Reset
				self:registerEventHandler( "clip_over", function ( element, event )
					self.total:setText( "" )
					
					for index = 1, 5 do
						self["text" .. index].score:setText( "" )
						self["text" .. index].name:setText( "" )
					end
				end )
			end
		end
	end )
end

CoD.T10PopupScore = InheritFrom( LUI.UIElement )
CoD.T10PopupScore.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10PopupScore )
	self.id = "T10PopupScore"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.total = LUI.UIText.new()
	self.total:setLeftRight( true, true, 0, -323 )
	self.total:setTopBottom( true, false, 292, 342 )
	self.total:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.total:setRGB( 1, 0.80, 0.23 )
	self.total:setScale( 0.5 )
	self.total:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_RIGHT )
	self:addElement( self.total )

	self.text1 = CoD.T10PopupScoreText.new( menu, controller )
	self.text1:setLeftRight( true, true, 0, 0 )
	self.text1:setTopBottom( true, true, 0, 0 )
	self:addElement( self.text1 )

	self.text2 = CoD.T10PopupScoreText.new( menu, controller )
	self.text2:setLeftRight( true, true, 0, 0 )
	self.text2:setTopBottom( true, true, 20, 20 )
	self:addElement( self.text2 )
	
	self.text3 = CoD.T10PopupScoreText.new( menu, controller )
	self.text3:setLeftRight( true, true, 0, 0 )
	self.text3:setTopBottom( true, true, 40, 40 )
	self:addElement( self.text3 )
	
	self.text4 = CoD.T10PopupScoreText.new( menu, controller )
	self.text4:setLeftRight( true, true, 0, 0 )
	self.text4:setTopBottom( true, true, 60, 60 )
	self:addElement( self.text4 )
	
	self.text5 = CoD.T10PopupScoreText.new( menu, controller )
	self.text5:setLeftRight( true, true, 0, 0 )
	self.text5:setTopBottom( true, true, 80, 80 )
	self:addElement( self.text5 )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end,
			PopupAnim = function ()
				self:setupElementClipCounter( 6 )

				local PopupAnimFrame2 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 500, false, false, CoD.TweenType.Linear )
					end
	
					local bTop, bBottom, top, bottom = element:getLocalTopBottom()
					element:setTopBottom( bTop, bBottom, top + 20, bottom + 20 )
					element:setAlpha( 0 )
	
					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				local PopupAnimFrame1 = function ( element, event )
					if event.interrupted then
						PopupAnimFrame2( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 1500, false, false, CoD.TweenType.Linear )

						element:setAlpha( 1 )

						element:registerEventHandler( "transition_complete_keyframe", PopupAnimFrame2 )
					end
				end

				self.total:completeAnimation()
				self.total:setAlpha( 1 )
				self.total:setTopBottom( true, false, 292, 342 )
				PopupAnimFrame1( self.total, {} )

				self.text1:completeAnimation()
				self.text1:setAlpha( 1 )
				self.text1:setTopBottom( true, true, 0, 0 )
				PopupAnimFrame1( self.text1, {} )
				
				self.text2:completeAnimation()
				self.text2:setAlpha( 1 )
				self.text2:setTopBottom( true, true, 20, 20 )
				PopupAnimFrame1( self.text2, {} )
				
				self.text3:completeAnimation()
				self.text3:setAlpha( 1 )
				self.text3:setTopBottom( true, true, 40, 40 )
				PopupAnimFrame1( self.text3, {} )
				
				self.text4:completeAnimation()
				self.text4:setAlpha( 1 )
				self.text4:setTopBottom( true, true, 60, 60 )
				PopupAnimFrame1( self.text4, {} )
				
				self.text5:completeAnimation()
				self.text5:setAlpha( 1 )
				self.text5:setTopBottom( true, true, 80, 80 )
				PopupAnimFrame1( self.text5, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.total:close()
		element.text1:close()
		element.text2:close()
		element.text3:close()
		element.text4:close()
		element.text5:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
