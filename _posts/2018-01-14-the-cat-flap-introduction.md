---
layout: "post"
title: "the cat flap: introduction"
date: "2018-01-14"
tags: [cat, raspberry-pi]
---

My cat, as I tell anyone who'll listen, is a monster.

_warning: I'm going to talk about dead animals in this post._
{:.warning}

<!--more-->

![sleepy kitty](/assets/images/sleepycat.jpg)

He’s an adorable one, but a tyrant nonetheless. For starters he’s a big boy; not fat really, just built like a brick shithouse. That’s not much of a problem except it means he can take up more room when he’s trying to be annoying (which is always). No, the bigger problem is that my little kitty cat likes to hunt. And he is damn good at it.

![scratching at all the bells we put on his collar](/assets/images/scritch.gif)

adding a bell to his collar every time he brought in a sacrifice didn't seem to deter him
{:.caption}

And yeah, he’s got bells on his collar. 8 of them, at one point. Doesn’t do much. We’ve had to accept that if he wants to spend his time murdering baby bunnies, there ain’t nothing we can do to stop him.

What we can do, however, is put our collective foot down and say “not in my house”. If he can sneak his prize past all of us, reach his favourite bunny-eating spot under the bush in the garden, and do whatever disgusting thing cats do with dead rabbits, then alright. You win this round, cat. We’ll be along later to clean up the entrails you’ve dumped in the middle of the lawn. But if he tries to bring it into the house to show it off then it’s an entirely different story. If you want to think of this in a positive sense, there is a bright side; the ones he brings in are more likely to still be alive, either because he thinks we’re useless and wants to teach us to hunt, or because he thinks it’s just hilarious watching us running round the house trying to catch these terrified animals.

Aside from saving the occasional bunny, we also don’t want him getting blood on the carpet.

![sleeping under his bunny-eating bush](/assets/images/bunnyeatingbush.jpg)

this is his bunny eating bush
{:.caption}

Of course, we can’t stop him if we can’t see him. Sometimes there’s someone nearby when he emerges from the catflap who can summon help by loudly calling him a few choice names. Sometimes he helpfully announces his own arrival with a series of loud meows (albeit slightly muffled through his mouthful of rabbit). But sometimes we have no way of knowing until someone wanders into the dining room and finds him underneath the table crunching away on a bit of spinal cord.

![crunch away on bunny spinal cord](/assets/images/murderboy.jpg)

an actual thing that actually happened
{:.caption}

And that is where the Raspberry Pi (the point of this series of posts) comes in. Being the offspring of this man:

> [The Internet of Things meets Data Science. Automatic low-Gin level alerting.](https://t.co/pmsC37TYK9)
>
> ![gin monitor](https://pbs.twimg.com/media/CbE0zq3XEAAkRgF.jpg)
>
> &mdash; John Butcher (@JohnaldButcher)
>
> February 13, 2016

I of course realised that I could set up a camera pointing at the cat flap, use a few sensors to detect when the boy is using it, then set up various alerts via a website ([isthecat.in](http://isthecat.in)) and some web services like IFTTT and Instapush.

So that’s a quick introduction to the main reason why I have a camera aimed at my catflap. It’s taken me many failed setups to get this working the way I like it, so I’m planning to do a series of posts going through some of the different parts - what I have now, what didn’t work, and what I might do next.
