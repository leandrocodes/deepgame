package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_20_20_Morre extends ActorScript
{
	public var _Group:Group;
	public var _OutTime:Float;
	public var _InTime:Float;
	public var _TransitionStyle:String;
	
	/* ========================= Custom Event ========================= */
	public function _customEvent_Reload():Void
	{
		if(!(isTransitioning()))
		{
			if((_TransitionStyle == "Fade"))
			{
				reloadCurrentScene(createFadeOut(_OutTime), createFadeIn(_InTime));
			}
			else if((_TransitionStyle == "Blinds"))
			{
				reloadCurrentScene(createBlindsOut(_OutTime), createBlindsIn(_InTime));
			}
			else if((_TransitionStyle == "Bubbles"))
			{
				reloadCurrentScene(createBubblesOut(_OutTime), createBubblesIn(_InTime));
			}
			else if((_TransitionStyle == "Spotlight"))
			{
				reloadCurrentScene(createCircleOut(_OutTime), createCircleIn(_InTime));
			}
			else if((_TransitionStyle == "Blur"))
			{
				reloadCurrentScene(createPixelizeOut(_OutTime), createPixelizeIn(_InTime));
			}
			else if((_TransitionStyle == "Box"))
			{
				reloadCurrentScene(createRectangleOut(_OutTime), createRectangleIn(_InTime));
			}
			else if((_TransitionStyle == "Crossfade"))
			{
				reloadCurrentScene(null, createCrossfadeTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Up"))
			{
				reloadCurrentScene(null, createSlideUpTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Down"))
			{
				reloadCurrentScene(null, createSlideDownTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Left"))
			{
				reloadCurrentScene(null, createSlideLeftTransition(_OutTime));
			}
			else if((_TransitionStyle == "Slide Right"))
			{
				reloadCurrentScene(null, createSlideRightTransition(_OutTime));
			}
		}
	}
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Group", "_Group");
		nameMap.set("Out Time", "_OutTime");
		_OutTime = 0.5;
		nameMap.set("In Time", "_InTime");
		_InTime = 0.5;
		nameMap.set("Transition Style", "_TransitionStyle");
		_TransitionStyle = "";
		
	}
	
	override public function init()
	{
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(_Group,event.otherActor.getType(),event.otherActor.getGroup()))
			{
				if((event.thisFromLeft || event.thisFromRight))
				{
					recycleActor(actor);
					_customEvent_Reload();
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}