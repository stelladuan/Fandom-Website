DROP TABLE BelongsTo;
DROP TABLE Contains;
DROP TABLE Involves;
DROP TABLE IsAddedTo;
DROP TABLE IsTaggedWith;
DROP TABLE Likes;
DROP TABLE Bookmark;
DROP TABLE Note;
DROP TABLE Report;
DROP TABLE RI;
DROP TABLE Relationship;
DROP TABLE Character;
DROP TABLE Fandom;
DROP TABLE Tag;
DROP TABLE DigitalWork;
DROP TABLE Chapter;
DROP TABLE WrittenWork;
DROP TABLE WCRT;
DROP TABLE Work;
DROP TABLE SiteUser;

CREATE TABLE SiteUser (
                          Username VARCHAR(20) DEFAULT 'Deleted User',
                          Password VARCHAR(20) NOT NULL,
                          EmailAddress VARCHAR(256) NOT NULL,
                          IsModerator NUMBER(1) NOT NULL,
                          PRIMARY KEY (Username),
                          UNIQUE (EmailAddress)
);


CREATE TABLE Work (
                      WorkID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                      Title VARCHAR(256) NOT NULL,
                      Description VARCHAR(1250),
                      Author VARCHAR(20) NOT NULL,
                      TimeStamp DATE NOT NULL,
                      WorkType CHAR(7) NOT NULL
                          CHECK (WorkType IN ('digital', 'written')),
                      FOREIGN KEY (Author) REFERENCES SiteUser(Username)
                          ON DELETE CASCADE
);

CREATE TABLE WCRT (
                      WordCount INTEGER PRIMARY KEY,
                      ReadingTime INTEGER NOT NULL
);

CREATE TABLE WrittenWork (
                             WorkID INTEGER PRIMARY KEY,
                             ChapterCount INTEGER NOT NULL,
                             WordCount INTEGER NOT NULL,
                             Language VARCHAR(25) NOT NULL,
                             FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                                 ON DELETE CASCADE,
                             FOREIGN KEY (WordCount) REFERENCES WCRT(WordCount)
                                 ON DELETE CASCADE
);

CREATE TABLE Chapter (
                         WorkID INTEGER,
                         ChapterNumber INTEGER,
                         TextFile CLOB NOT NULL,
                         PRIMARY KEY (WorkID, ChapterNumber),
                         FOREIGN KEY (WorkID) REFERENCES WrittenWork(WorkID)
                             ON DELETE CASCADE
);

CREATE TABLE DigitalWork (
                             WorkID INTEGER PRIMARY KEY,
                             ImageFile VARCHAR(256) NOT NULL,
                             FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                                 ON DELETE CASCADE
);

CREATE TABLE Tag (
    TagContent VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Fandom (
    FandomName VARCHAR(100) PRIMARY KEY
);

CREATE TABLE Character (
                           CharacterName VARCHAR(100),
                           FandomName VARCHAR(100),
                           PRIMARY KEY (FandomName, CharacterName),
                           FOREIGN KEY (FandomName) REFERENCES Fandom(FandomName)
                               ON DELETE CASCADE
);

CREATE TABLE Relationship (
                              PairingName VARCHAR(310) PRIMARY KEY,
                              IsRomantic NUMBER(1) NOT NULL,
                              Character1Name VARCHAR(100) NOT NULL,
                              Character1Fandom VARCHAR(100) NOT NULL,
                              Character2Name VARCHAR(100) NOT NULL,
                              Character2Fandom VARCHAR(100) NOT NULL,
                              UNIQUE (IsRomantic, Character1Name, Character1Fandom,
                                      Character2Name, Character2Fandom),
                              FOREIGN KEY (Character1Fandom, Character1Name) REFERENCES Character(FandomName, CharacterName)
                                  ON DELETE CASCADE,
                              FOREIGN KEY (Character2Fandom, Character2Name) REFERENCES Character(FandomName, CharacterName)
                                  ON DELETE CASCADE
);

CREATE TABLE RI (
                    Reason VARCHAR(33) PRIMARY KEY,
                    Issue CHAR(18) NOT NULL
                        CHECK (Issue IN ('Suspicious or spam', 'Abusive or harmful'))
);

CREATE TABLE Report (
                        ReportID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                        Reason VARCHAR(33) NOT NULL
                            CHECK(Reason IN ('Malicious or phishing attempt', 'Work has been posted before',
                                             'Work contains spam', 'Tags are unrelated to work', 'Disrespectful or offensive',
                                             'Includes private information', 'Targeted harassment', 'Directs hate on a protected group', 'Threatening or encouraging harm')),
                        Description VARCHAR(1250),
                        TimeStamp DATE NOT NULL,
                        Username VARCHAR(20) NOT NULL,
                        WorkID INTEGER NOT NULL,
                        FOREIGN KEY (Reason) REFERENCES RI(Reason)
                            ON DELETE CASCADE,
                        FOREIGN KEY (Username) REFERENCES SiteUser(Username)
                            ON DELETE CASCADE,
                        FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                            ON DELETE CASCADE
);

CREATE TABLE Note (
                      NoteID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                      TextContent VARCHAR(4000) NOT NULL,
                      TimeStamp DATE NOT NULL,
                      Username VARCHAR(20) NOT NULL,
                      WorkID INTEGER NOT NULL,
                      FOREIGN KEY (Username) REFERENCES SiteUser(Username)
                          ON DELETE CASCADE,
                      FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                          ON DELETE CASCADE
);

CREATE TABLE Bookmark (
                          BookmarkID INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                          Note VARCHAR(256),
                          IsPublic NUMBER(1) NOT NULL,
                          TimeStamp DATE NOT NULL,
                          Username VARCHAR(20) NOT NULL,
                          WorkID INTEGER NOT NULL,
                          FOREIGN KEY (Username) REFERENCES SiteUser(Username)
                              ON DELETE CASCADE,
                          FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                              ON DELETE CASCADE
);

CREATE TABLE Likes (
                       Username VARCHAR(20),
                       WorkID INTEGER,
                       TimeStamp DATE NOT NULL,
                       PRIMARY KEY (Username, WorkID),
                       FOREIGN KEY (Username) REFERENCES SiteUser(Username)
                           ON DELETE CASCADE,
                       FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                           ON DELETE CASCADE
);

CREATE TABLE IsTaggedWith (
                              BookmarkID INTEGER,
                              Tag VARCHAR(100),
                              PRIMARY KEY (BookmarkID, Tag),
                              FOREIGN KEY (BookmarkID) REFERENCES Bookmark(BookmarkID)
                                  ON DELETE CASCADE,
                              FOREIGN KEY (Tag) REFERENCES Tag(TagContent)
                                  ON DELETE CASCADE
);

CREATE TABLE IsAddedTo (
                           WorkID INTEGER,
                           Tag VARCHAR(100),
                           PRIMARY KEY (WorkID, Tag),
                           FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                               ON DELETE CASCADE,
                           FOREIGN KEY (Tag) REFERENCES Tag(TagContent)
                               ON DELETE CASCADE
);

CREATE TABLE Involves (
                          WorkID INTEGER,
                          Pairing VARCHAR(310),
                          PRIMARY KEY (WorkID, Pairing),
                          FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                              ON DELETE CASCADE,
                          FOREIGN KEY (Pairing) REFERENCES Relationship(PairingName)
                              ON DELETE CASCADE
);

CREATE TABLE Contains (
                          WorkID INTEGER,
                          CharacterName VARCHAR(100),
                          FandomName VARCHAR(100),
                          PRIMARY KEY (WorkID, CharacterName, FandomName),
                          FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                              ON DELETE CASCADE,
                          FOREIGN KEY (CharacterName, FandomName) REFERENCES Character(CharacterName, FandomName)
                              ON DELETE CASCADE
);

CREATE TABLE BelongsTo (
                           WorkID INTEGER,
                           FandomName VARCHAR(100),
                           PRIMARY KEY  (WorkID, FandomName),
                           FOREIGN KEY (WorkID) REFERENCES Work(WorkID)
                               ON DELETE CASCADE,
                           FOREIGN KEY (FandomName) REFERENCES Fandom(FandomName)
                               ON DELETE CASCADE
);



INSERT INTO SiteUser VALUES ('user1', 'password', 'pencilsharpener@gmail.com', 0);
INSERT INTO SiteUser VALUES('blue123', '9SPhPqZ529', 'blue123@yahoo.com', 0);
INSERT INTO SiteUser VALUES('greatwriter', 'pi7eyBSRenTv9xP', 'dave@gmail.com', 0);
INSERT INTO SiteUser VALUES('acelover', 'trinityton110', 'ace_dolphin@gmail.com', 1);
INSERT INTO SiteUser VALUES('pinkpetal', 'y3Xow7nXZ', 'pinkpetal@hotmail.com', 1);


INSERT INTO Work VALUES(DEFAULT, 'The Champion of Harmony', 'Lorem ipsum dolor sit amet', 'user1', DATE'2020-05-04', 'written');
INSERT INTO Work VALUES(DEFAULT, 'No Longer Alone', 'consectetuer adipiscing elit', 'user1',  DATE'2020-08-13', 'written');
INSERT INTO Work VALUES(DEFAULT, 'Blue123s Headcanons', 'Sed ut perspiciatis', 'blue123', DATE'2021-01-31', 'written');
INSERT INTO Work VALUES(DEFAULT, 'A Second Chance', 'unde omnis iste natus error', 'greatwriter', DATE'2021-02-10', 'digital');
INSERT INTO Work VALUES(DEFAULT, 'Shooting Stars', 'The quick, brown fox jumps over a lazy dog.', 'pinkpetal', DATE'2021-02-10', 'digital');
INSERT INTO Work VALUES(DEFAULT, 'cornerstones', '&quot;Am I worthy?&quot; echoes a voice, thick and sultry but entirely too hard to grasp.
<br>
<br>&quot;No,&quot; Akali growls. &quot;None of you are.&quot;', 'acelover', DATE'2021-02-11', 'written');
INSERT INTO Work VALUES(DEFAULT, 'crossroads', 'Curabitur ullamcorper ultricies nisi.', 'pinkpetal', DATE'2021-03-01', 'digital');
INSERT INTO Work VALUES(DEFAULT, 'briar rose', 'Sed consequat', 'greatwriter', DATE'2021-03-04', 'written');
INSERT INTO Work VALUES(DEFAULT, 'Dream Gone By', 'Nullam accumsan lorem in dui.', 'user1', DATE'2021-03-06', 'digital');
INSERT INTO Work VALUES(DEFAULT, 'lost sentences', 'Duis arcu tortor, suscipit eget.', 'acelover', DATE'2021-04-10', 'digital');



INSERT INTO WCRT VALUES(29773, 120);
INSERT INTO WCRT VALUES(2050, 10);
INSERT INTO WCRT VALUES(78, 5);
INSERT INTO WCRT VALUES(6890, 30);
INSERT INTO WCRT VALUES(3280, 15);
INSERT INTO WCRT VALUES(0, 0);


INSERT INTO WrittenWork VALUES(1, 3, 29773, 'english');
INSERT INTO WrittenWork VALUES(2, 1, 2050, 'korean');
INSERT INTO WrittenWork VALUES(3, 1, 78, 'english');
INSERT INTO WrittenWork VALUES(6, 4, 6890, 'english');
INSERT INTO WrittenWork VALUES(8, 1, 3280, 'latin');


INSERT INTO Chapter VALUES (1, 1, 'Far far away ...');
INSERT INTO Chapter VALUES(1, 2, 'Separated they live in Bookmarksgrove ...');
INSERT INTO Chapter VALUES(2, 1, 'A small river ...');
INSERT INTO Chapter VALUES(1, 3, 'Roasted parts of sentences ...');
INSERT INTO Chapter VALUES(3, 1, 'One day however ...');
INSERT INTO Chapter VALUES(6, 1, 'All members of the Blood Moon seek out demons that will accept them, that will give them the opportunity of becoming one to embrace the oncoming darkness of the world. It is this desire that creates the foundation of this cult, that propels its members forward day by day. To refuse such an overture, if granted to them, is considered to be incredibly disrespectful. But, all humans carry an innate drive to be the best; it is understandable, though still frowned upon, if one refutes the powers of a puny demon. Pride is an important thing to the Blood Moon, and to be rejected by a mortal of all things is the greatest insult of them all.
<br>
<br>As such, if this does happen, the cultist is killed the following day by the demon that gave the offer, one of the assassins of the cult, or perhaps even by the Blood Moon itself. The latter of the three is the most uncommon, of course. Such an occurrence is usually reserved for tricky individuals that have hidden themselves away, in an attempt to escape their inevitable demise, with hopes of finding a stronger beast for themselves to tame. Unfortunately for them, the Blood Moon sees all, and their deaths are almost always the most painfulâ¦
<br>
<br>...at least, for all except one.
<br>
<br>Many have heard of this priestess'' unnatural power, and wanted to claim it for their own. But, when the first dared to step forth with their offer - a tiny thing not much stronger than your average huntsman - Akali refused the offer without sparing even a glance at the demon. When two others came the next day, they were turned down with a distasteful gaze. When a demon decorated in the jewels of their victim''s flesh, a demon that radiated an arrogance that forced surrounding demons to kneel, came to her, she turned her back and left without even uttering a word.
<br>
<br>(That demon was found dead next day, when it tried to pursue her with an invitation of death.)
<br>
<br>Unlike others, however, she didn''t run; she stood under the open night, unarmed and unmasked, waiting for the Blood Moon to come to her. The demons could not surpass her shroud no matter how hard they tried; the assassins found no fun in murdering prey that would not flee from them, nor victims that would not cry out in agony.
<br>
<br>Akali kneeled, in the open courtyard where the moonlight shone the strongest, and waited - thinking, meditating, taunting.
<br>
<br>The outrage that fell around her was enough to uproot plants, bushes, and some withering old trees, but Akali stayed firmly put on the ground. The only indication that she wasn''t a statue was how her garbs fluttered in the storm erratically, how her hair whipped around wildly to become a mess of ebony and crimson streaks in the quickly-darkening skies.
<br>
<br>Nothing was brave enough to insult the Blood Moon, for that would surely bring upon something worse than death. Still, here Akali was, expression completely blank despite the chaos that rushed around her. It was almost as if she was daring the Blood Moon to come forth and battle her.
<br>
<br>Stones flew by. One dug itself into her face, right below her eye, leaving a streak of blood that slowly trailed down her cheek. Another did the same, but underneath her other eye. The wounds burned with a sort of pain unattainable by a simple scrape. They were more than just cuts - they were a challenge, an acceptance of her dare, to test her and see if she was worthy.
<br>
<br>The storm raged endlessly for four days, unabating and only ever growing in size. Anyone that even tried to go near it got swept off their feet and dragged into the vortex.');
INSERT INTO Chapter VALUES(6, 2, 'When it finally ceased, the only thing that survived its carnage was Akali, still kneeling in the middle of the field. Her clothes were almost pristine, as if new; her body was relatively unharmed. The only things that changed about her were the two red marks that now rested under the corners of each eye, and the steel resolve that began to bloom in her gaze.
<br>
<br>No one knows what truly happened. Akali refused to comment on what occurred, instead choosing to leave and isolate herself in the woods. Those who were present, watching the chaos unfold with wide eyes, went mad - they claimed to have heard whispers, utterings of an old language, laced with heavy accents and brittle syllables. Others, watching from a much safer distance, saw the outline of the moon in the gales, but also the shadow of an ancient dragon. One claimed to have seen feathered wings of white and gold, curved bronze horns, and vibrant red eyes that sparked with malevolence. He claimed that this beast was the cause the storm, that these were the signs of the progenitor, the rancorous darkness himself.
<br>
<br>Regardless of what truly occurred, everyone was certain of one thing, at least: the Blood Moon spoke to Akali, and Akali came out alive.
<br>
<br>Even in her absence, Akali was heralded as a legend. Rumours emerged, stating that she was a chosen one, and she would be the one to usher in a greater era for the Blood Moon clan. Tales of her powers were manipulated to sound grandiose, to the point where she was given the name of Hei long - black dragon. This name was chosen in reference to the eastern dragon some insisted they saw during the storm, surging around the glow of the moon as if the two were fighting.
<br>
<br>As days turned into months, and months turned into years, much of the cult realized that Akali would not be coming back. Though her ambitions would always be remembered, what seemed to be her abandonment of the Blood Moon left a bitter taste in many of the cultists'' mouths. She was never formally exiled, per se; a great deal of the clan simply refused to be associated with her. Eventually, her tale melded together with other stories of the cult, and the fact that the Hei long had been - and still is - a real person was forgotten by most mortals.
<br>
<br>Within the realm of the demons, however, she became one of the many individuals that the demons would dream to become one with. Prior to her, no one had ever challenged the Blood Moon and gotten out alive, much less unscathed. And, although she hadn''t left without marks symbolizing the event (as demonstrated by the swipes of blood that permanently stained her cheeks now), the fact that she still walked the land of mortals made her that much of a desirable host.
<br>
<br>Even though it was generally known that Akali has turned down every single demon that sought her out, it didn''t stop the majority of them from trying. All of them - ranging from the lowest of the low to the greatest of the great - would find her newest hideaway and extend to her an offer of supposed eminence. And as always, they would all be turned down and left with shattered prides. Those that dared to raise their powers against her would never be heard from again.
<br>
<br>Some say that the priestess'' true desire is to become one with the Blood Moon itself. They say that she isolated herself to further hone her skills, in order to impress the Blood Moon enough that such an anonymity would consider unifying itself with her. Others - most - say that she just has not found a worthy candidate yet. It is this shard of hope that still drives many of the newer, younger demons to try their luck with her.
<br>
<br>Whatever the case may be, Akali still walks the earth in her own flesh, and the demons still want that body for their own.');
INSERT INTO Chapter VALUES(6, 3, 'Evelynn''s not sure when she started following the girl around, nor can she exactly remember the reason why she did it. She tries to argue with herself, claiming that the girl reeks of so much unresolved despair that simply standing beside her is enough to sate her hunger. Being near her is all she needs to do; she doesn''t ever have to go search, hunt, and charm another soul again. It''s the quiet, tireless life she so desires. The girl''s company is just a bonus, a mortal to keep her company as she waits for the end to come.
<br>
<br>Even in her head, she can''t believe her own words. So she tries a different approach: she wants this girl - the Hei long -  to be hers. As arrogant as Evelynn may be, she can''t deny the fact that the girl possesses extraordinary powers of her own. That shroud is unbelievably oppressive - she doesn''t even understand how the girl herself can see through that thick, suffocating smoke. Her proficiency with her kama and kunai are also both unique and impressive, not to mention her stealth and fighting technique; Evelynn can still feel the prickles of pain, on her cheek and her neck, from where the girl has nicked her from before.
<br>
<br>''I can''t fool myself,'' Evelynn thinks bitterly, staring down at Akali''s resting face, eyes shut tightly and her maroon-tipped hair loose, spread underneath her cheek after being undone from its hair tie.
<br>
<br>Still, she tries to think. ''When did I decide to stay? Why did I decide to stay? Where was I when I made the decision? What was I doing? What...''
<br>
<br>Her eyes shift downward, gazing at the two swipes of red under Akali''s eyes.
<br>
<br>''...When did I start thinking of her by her name?''
<br>
<br>''Why did I refer to her by her name? Why do I keep calling her by her name? How has she not berated me for doing so? Have I even spoken her name out loud, yet? When did she become so calm about all of this? Why is she so relaxed around me? Why does she allow me to touch her? When did I start noticing these things? When did I notice these marks? When did I realize that they were dried blood, from the Blood Moon itself? Why do I know this? What am I doing? Why am I -''
<br>
<br>Mmmm...&quot; Akali mumbles, shifting on her futon. She screws her eyes for a moment before they blink open blearily. &quot;...Eve?&quot;
<br>
<br>Her heart flutters. &quot;...Akali.&quot; The name feels foreign but oh so perfect on her tongue, more tasteful than any heart she''s ever devoured before, more appetizing than any mortal misery she''s feasted on in her lifetime.
<br>
<br>The girl makes another noise, a mix between a whine and a grumble. Her eyes flicker close. &quot;...Stop...stop thinking so much.&quot; She lets out a huff through her nose. &quot;No point...no point in questions th...that can''t be solved.&quot;
<br>
<br>Akali rolls over, back now facing her, and that''s when Evelynn finds all the answers to all her problems.');
INSERT INTO Chapter VALUES(6, 4, '&quot;Mortal girls aren''t supposed to be warriors,&quot; Evelynn mentions after she rests her chin on Akali''s stomach. Akali flinches a little, curses under her breath as the action pulls a bit painfully at her side. The wound burns with an intensity that makes her briefly see stars for a moment, reminding her of today''s negligence, but so does Evelynn''s pride, still stinging for not being fast enough to stop the blow.
<br>
<br>(The sound of his grotesque sobbing, his ear-piercing shrieking - it was music to her ears ).
<br>
<br>&quot;You''re sitting in front of one right now,&quot; Akali counters, eyes creased slightly in pain, but there''s no bitter sharpness in her tone, no veiled aggression in her words.
<br>
<br>&quot;Well then,&quot; she replies, tracing the bloodstained skin under Akali''s eye. &quot;I suppose you''re just an exception.&quot;
<br>
<br>Akali shifts around in the cotton bed a little, wincing with her movements but finally getting into a more comfortable position. Her eyes become a little distant for a brief moment, then a few seconds, and almost half a minute and Evelynn thinks that something might have happened to her -
<br>
<br>&quot;Why?&quot;
<br>
<br>Evelynn has to blink once, then twice, to realize that the cloudiness is just a layer of tears forming at the edges of Akali''s eyes. She tries to close them before any fall, but one manages to slip out and create a luminescent streak down the side of her cheek.
<br>
<br>&quot;Why me, Evelynn?&quot; Akali echoes again, only opening her eyes once she''s sure that all of the tears have disappeared.
<br>
<br>It''s deathly quiet for almost several minutes. Akali can''t quite see Evelynn''s face, so she turns her head slightly and notices the way her brows furrow in not concentration, but something along the lines of...worry?');
INSERT INTO Chapter VALUES(8, 1, 'When she reached the first hills ...');


INSERT INTO DigitalWork VALUES(4, 'https://danbooru.donmai.us/data/sample/8c/c8/sample-8cc858e6177028a7a0d2491ccd80cf63.jpg');
INSERT INTO DigitalWork VALUES(5, 'https://pbs.twimg.com/media/EG-WGAbUEAE-7CN.jpg');
INSERT INTO DigitalWork VALUES(7, 'https://i.imgur.com/12tiPBO.jpg');
INSERT INTO DigitalWork VALUES(9, 'https://pbs.twimg.com/media/ELQ1bk5VUAAK59-.jpg');
INSERT INTO DigitalWork VALUES(10, 'https://pbs.twimg.com/media/EuxMouNUcAIliuT.jpg');


INSERT INTO Tag VALUES('angst');
INSERT INTO Tag VALUES('worldbuilding');
INSERT INTO Tag VALUES('symbolism');
INSERT INTO Tag VALUES('fluff');
INSERT INTO Tag VALUES('time travel');


INSERT INTO Fandom VALUES ('genshin impact');
INSERT INTO Fandom VALUES('xenoblade chronicles 2');
INSERT INTO Fandom VALUES('my little pony: friendship is magic');
INSERT INTO Fandom VALUES('league of legends');
INSERT INTO Fandom VALUES('touhou project');


INSERT INTO Character VALUES('ganyu', 'genshin impact');
INSERT INTO Character VALUES('keqing', 'genshin impact');
INSERT INTO Character VALUES('jin', 'xenoblade chronicles 2');
INSERT INTO Character VALUES('lora', 'xenoblade chronicles 2');
INSERT INTO Character VALUES('twilight sparkle', 'my little pony: friendship is magic');
INSERT INTO Character VALUES('rainbow dash', 'my little pony: friendship is magic');
INSERT INTO Character VALUES('rarity', 'my little pony: friendship is magic');
INSERT INTO Character VALUES('akali', 'league of legends');
INSERT INTO Character VALUES('evelynn', 'league of legends');


INSERT INTO Relationship VALUES('ganyu/keqing', 1, 'ganyu', 'genshin impact', 'keqing', 'genshin impact');
INSERT INTO Relationship VALUES('jin & lora', 0, 'jin', 'xenoblade chronicles 2', 'lora', 'xenoblade chronicles 2');
INSERT INTO Relationship VALUES('rarity/twilight sparkle', 1, 'rarity', 'my little pony: friendship is magic', 'twilight sparkle', 'my little pony: friendship is magic');
INSERT INTO Relationship VALUES('rainbow dash/twilight sparkle', 1, 'rainbow dash', 'my little pony: friendship is magic', 'twilight sparkle', 'my little pony: friendship is magic');
INSERT INTO Relationship VALUES('rainbow dash & twilight sparkle', 0, 'rainbow dash', 'my little pony: friendship is magic', 'twilight sparkle', 'my little pony: friendship is magic');
INSERT INTO Relationship VALUES('akali/evelynn', 1, 'akali', 'league of legends', 'evelynn', 'league of legends');


INSERT INTO RI VALUES('Malicious or phishing attempt', 'Suspicious or spam');
INSERT INTO RI VALUES('Work has been posted before', 'Suspicious or spam');
INSERT INTO RI VALUES('Work contains spam', 'Suspicious or spam');
INSERT INTO RI VALUES('Tags are unrelated to work', 'Suspicious or spam');
INSERT INTO RI VALUES('Disrespectful or offensive', 'Abusive or harmful');
INSERT INTO RI VALUES('Includes private information', 'Abusive or harmful');
INSERT INTO RI VALUES('Targeted harassment', 'Abusive or harmful');
INSERT INTO RI VALUES('Directs hate on a protected group', 'Abusive or harmful');
INSERT INTO RI VALUES('Threatening or encouraging harm', 'Abusive or harmful');


INSERT INTO Report VALUES(DEFAULT, 'Malicious or phishing attempt', 'The fic contains a link to a phishing site which stole all my important information', DATE '2020-08-01', 'greatwriter', 1);
INSERT INTO Report VALUES(DEFAULT, 'Work has been posted before', 'work 1 has been posted before, plz remove thx', DATE '2020-08-01', 'greatwriter', 2);
INSERT INTO Report VALUES(DEFAULT, 'Tags are unrelated to work', 'this work is in the genshin impact tag when its about harry potter!!1!1', DATE '2020-08-01', 'user1', 3);
INSERT INTO Report VALUES(DEFAULT, 'Disrespectful or offensive', 'this pic burned my house down and stole my shoes please delete it', DATE '2020-08-01', 'blue123', 4);
INSERT INTO Report VALUES(DEFAULT, 'Threatening or encouraging harm', 'the art is glorifying self-harm', DATE '2020-08-01', 'greatwriter', 5);


INSERT INTO Note VALUES(DEFAULT, 'great work!', DATE '2020-06-06', 'acelover', 2);
INSERT INTO Note VALUES(DEFAULT, 'omg I ship these two so hard', DATE '2020-07-06', 'pinkpetal', 10);
INSERT INTO Note VALUES(DEFAULT, 'I think this is spam...', DATE '2021-05-23', 'blue123', 3);
INSERT INTO Note VALUES(DEFAULT, 'THIS FIC CONTAINS A LINK TO A PHISHING SITE. I AM WARNING YOU RIGHT NOW DO NOT READ IT', DATE '2020-08-01', 'greatwriter', 1);
INSERT INTO Note VALUES(DEFAULT, '@greatwriter lol no it doesnt', DATE '2020-08-02', 'user1', 1);


INSERT INTO Bookmark VALUES(DEFAULT, 'Read later', 1, DATE '2020-05-05', 'pinkpetal', 1);
INSERT INTO Bookmark VALUES(DEFAULT, 'Read later', 1, DATE '2020-05-06', 'pinkpetal', 2);
INSERT INTO Bookmark VALUES(DEFAULT, NULL, 0, DATE '2020-04-14', 'acelover', 10);
INSERT INTO Bookmark VALUES(DEFAULT, 'nice stuff', 0, DATE '2020-04-14', 'blue123', 2);
INSERT INTO Bookmark VALUES(DEFAULT, NULL, 1, DATE '2020-02-1', 'blue123', 3);


INSERT INTO Likes VALUES('user1', 1, DATE'2021-02-10');
INSERT INTO Likes VALUES('blue123', 1, DATE'2021-02-10');
INSERT INTO Likes VALUES('greatwriter', 1, DATE'2021-02-10');
INSERT INTO Likes VALUES('acelover', 1, DATE'2021-02-10');
INSERT INTO Likes VALUES('pinkpetal', 1, DATE'2021-02-11');
INSERT INTO Likes VALUES('user1', 3, DATE'2021-02-10');
INSERT INTO Likes VALUES('blue123', 3, DATE'2021-02-10');
INSERT INTO Likes VALUES('greatwriter', 3, DATE'2021-02-10');
INSERT INTO Likes VALUES('acelover', 3, DATE'2021-02-10');
INSERT INTO Likes VALUES('pinkpetal', 3, DATE'2021-02-11');
INSERT INTO Likes VALUES('user1', 2, DATE'2021-02-10');
INSERT INTO Likes VALUES('pinkpetal', 5, DATE'2021-02-11');


INSERT INTO IsTaggedWith VALUES(1, 'angst');
INSERT INTO IsTaggedWith VALUES(2, 'angst');
INSERT INTO IsTaggedWith VALUES(3, 'worldbuilding');
INSERT INTO IsTaggedWith VALUES(4, 'fluff');
INSERT INTO IsTaggedWith VALUES(5, 'worldbuilding');


INSERT INTO IsAddedTo VALUES(1, 'angst');
INSERT INTO IsAddedTo VALUES(2, 'angst');
INSERT INTO IsAddedTo VALUES(6, 'worldbuilding');
INSERT INTO IsAddedTo VALUES(3, 'time travel');
INSERT INTO IsAddedTo VALUES(8, 'symbolism');


INSERT INTO Involves VALUES(4, 'jin & lora');
INSERT INTO Involves VALUES(3, 'rainbow dash/twilight sparkle');
INSERT INTO Involves VALUES(3, 'rainbow dash & twilight sparkle');
INSERT INTO Involves VALUES(3, 'rarity/twilight sparkle');
INSERT INTO Involves VALUES(6, 'akali/evelynn');
INSERT INTO Involves VALUES(10, 'ganyu/keqing');


INSERT INTO Contains VALUES(4, 'jin', 'xenoblade chronicles 2');
INSERT INTO Contains VALUES(4, 'lora', 'xenoblade chronicles 2');
INSERT INTO Contains VALUES(3, 'twilight sparkle', 'my little pony: friendship is magic');
INSERT INTO Contains VALUES(3, 'rainbow dash', 'my little pony: friendship is magic');
INSERT INTO Contains VALUES(3, 'rarity', 'my little pony: friendship is magic');
INSERT INTO Contains VALUES(6, 'akali', 'league of legends');
INSERT INTO Contains VALUES(6, 'evelynn', 'league of legends');
INSERT INTO Contains VALUES(10, 'ganyu', 'genshin impact');
INSERT INTO Contains VALUES(10, 'keqing', 'genshin impact');


INSERT INTO BelongsTo VALUES(1, 'my little pony: friendship is magic');
INSERT INTO BelongsTo VALUES(2, 'my little pony: friendship is magic');
INSERT INTO BelongsTo VALUES(3, 'my little pony: friendship is magic');
INSERT INTO BelongsTo VALUES(4, 'xenoblade chronicles 2');
INSERT INTO BelongsTo VALUES(5, 'touhou project');
INSERT INTO BelongsTo VALUES(6, 'league of legends');
INSERT INTO BelongsTo VALUES(7, 'genshin impact');
INSERT INTO BelongsTo VALUES(8, 'touhou project');
INSERT INTO BelongsTo VALUES(9, 'league of legends');
INSERT INTO BelongsTo VALUES(10, 'genshin impact');