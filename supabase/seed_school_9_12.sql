-- =====================================================================
-- PRACTICE QUESTION BANK: Class 9 to 12
-- Subjects: gk, current_affairs, maths, physics, chemistry, biology
-- Bands: Class 9-10 and Class 11-12 (8 questions per subject per band)
-- Run AFTER phase6_practice.sql. Safe to run again (deletes old rows first).
-- NOTE: Current Affairs questions are as of 2025. Refresh them every year.
-- =====================================================================

delete from public.practice_questions
where education_type = 'school' and min_standard >= 9;

insert into public.practice_questions
  (subject, education_type, min_standard, max_standard,
   question_text, option_a, option_b, option_c, option_d, correct_option, explanation)
values
-- ---------------- GK : Class 9-10 ----------------
('gk','school',9,10,'Which Article of the Indian Constitution abolishes untouchability?','Article 14','Article 17','Article 21','Article 32','B','Article 17 abolishes untouchability and forbids its practice.'),
('gk','school',9,10,'Who is known as the "Iron Man of India"?','Bal Gangadhar Tilak','Lala Lajpat Rai','Sardar Vallabhbhai Patel','Bhagat Singh','C','Sardar Patel united over 560 princely states with India.'),
('gk','school',9,10,'Who wrote the book "The Discovery of India"?','Jawaharlal Nehru','Mahatma Gandhi','B. R. Ambedkar','Rabindranath Tagore','A','Nehru wrote it in Ahmednagar Fort prison (1942-46).'),
('gk','school',9,10,'Which Indian state has the longest coastline?','Tamil Nadu','Andhra Pradesh','Maharashtra','Gujarat','D','Gujarat has the longest coastline among Indian states.'),
('gk','school',9,10,'What is the currency of Japan?','Yuan','Yen','Won','Ringgit','B','Japan uses the Yen; China uses the Yuan; Korea uses the Won.'),
('gk','school',9,10,'In which year was the Battle of Plassey fought?','1857','1764','1757','1947','C','In 1757 the East India Company defeated Siraj-ud-Daulah at Plassey.'),
('gk','school',9,10,'Which is the largest hot desert in the world?','Thar','Gobi','Kalahari','Sahara','D','The Sahara in North Africa is the largest hot desert.'),
('gk','school',9,10,'Who is the chairperson of NITI Aayog?','President of India','Prime Minister of India','Finance Minister','RBI Governor','B','The Prime Minister is the ex-officio chairperson of NITI Aayog.'),

-- ---------------- Current Affairs : Class 9-10 ----------------
('current_affairs','school',9,10,'Which Indian astronaut flew to the ISS on the Axiom-4 mission in 2025?','Shubhanshu Shukla','Rakesh Sharma','Kalpana Chawla','Sunita Williams','A','Group Captain Shubhanshu Shukla became the first Indian aboard the ISS.'),
('current_affairs','school',9,10,'What is the name of India''s first human spaceflight programme?','Mangalyaan','Chandrayaan','Gaganyaan','Aditya','C','Gaganyaan aims to send Indian astronauts to space on an Indian rocket.'),
('current_affairs','school',9,10,'India beat which team in the final of the 2024 ICC Men''s T20 World Cup?','Australia','England','New Zealand','South Africa','D','India beat South Africa by 7 runs in Barbados in June 2024.'),
('current_affairs','school',9,10,'How many medals did India win at the Paris Olympics 2024?','4','6','7','10','B','India won 6 medals: 1 silver and 5 bronze.'),
('current_affairs','school',9,10,'Who was elected Pope in May 2025, taking the name Leo XIV?','Robert Francis Prevost','Pietro Parolin','Luis Antonio Tagle','Peter Turkson','A','Cardinal Robert Prevost became the first Pope from the United States.'),
('current_affairs','school',9,10,'In which year was India''s new Parliament building inaugurated?','2021','2022','2023','2024','C','The new Parliament building was inaugurated on 28 May 2023.'),
('current_affairs','school',9,10,'Which ISRO mission made India the 4th country to dock two satellites in space (January 2025)?','Aditya-L1','SpaDeX','NISAR','XPoSat','B','SpaDeX means Space Docking Experiment.'),
('current_affairs','school',9,10,'"Viksit Bharat" is the goal of making India a developed nation by which year?','2030','2035','2050','2047','D','2047 marks 100 years of Indian independence.'),

-- ---------------- Maths : Class 9-10 ----------------
('maths','school',9,10,'What are the roots of x² - 5x + 6 = 0?','2 and 3','-2 and -3','1 and 6','-1 and 6','A','x² - 5x + 6 = (x - 2)(x - 3), so x = 2 or 3.'),
('maths','school',9,10,'What is the value of sin 30°?','1','1/2','√3/2','0','B','sin 30° = 1/2.'),
('maths','school',9,10,'What is the HCF of 36 and 48?','6','8','12','24','C','36 = 2²·3², 48 = 2⁴·3, so HCF = 2²·3 = 12.'),
('maths','school',9,10,'What is the sum of the first 10 natural numbers?','45','50','100','55','D','n(n+1)/2 = 10 x 11 / 2 = 55.'),
('maths','school',9,10,'Area of a circle of radius 7 cm (take π = 22/7)?','44 cm²','154 cm²','144 cm²','49 cm²','B','πr² = 22/7 x 7 x 7 = 154 cm².'),
('maths','school',9,10,'What is the probability of getting a head when a fair coin is tossed?','1','0','1/2','1/4','C','There are 2 equally likely outcomes, and 1 is a head.'),
('maths','school',9,10,'What is the distance between the points (0, 0) and (3, 4)?','5','7','12','25','A','√(3² + 4²) = √25 = 5.'),
('maths','school',9,10,'Which of these is an irrational number?','0.5','3/4','√4','√2','D','√2 cannot be written as p/q; √4 = 2 is rational.'),

-- ---------------- Physics : Class 9-10 ----------------
('physics','school',9,10,'What is the SI unit of work?','Newton','Joule','Watt','Pascal','B','Work = force x distance, measured in joules.'),
('physics','school',9,10,'What is the approximate acceleration due to gravity on Earth?','9.8 m/s²','8.9 m/s²','10.8 m/s²','6.7 m/s²','A','g is about 9.8 m/s² near the Earth''s surface.'),
('physics','school',9,10,'Newton''s third law says every action has?','No reaction','A greater reaction','An equal and opposite reaction','A delayed reaction','C','Forces always come in equal and opposite pairs.'),
('physics','school',9,10,'According to Ohm''s law, V = ?','I / R','R / I','I + R','I x R','D','Voltage = current x resistance.'),
('physics','school',9,10,'Which mirror is used as a rear-view mirror in vehicles?','Concave','Convex','Plane','Cylindrical','B','A convex mirror gives a wider field of view.'),
('physics','school',9,10,'What is the unit of electrical resistance?','Volt','Ampere','Ohm','Watt','C','Resistance is measured in ohms (Ω).'),
('physics','school',9,10,'Sound cannot travel through?','Vacuum','Water','Steel','Air','A','Sound needs a medium; there is nothing to vibrate in a vacuum.'),
('physics','school',9,10,'The power of a lens is measured in?','Watt','Lux','Metre','Dioptre','D','Power = 1 / focal length (in metres), unit dioptre (D).'),

-- ---------------- Chemistry : Class 9-10 ----------------
('chemistry','school',9,10,'What is the pH of pure water at 25 °C?','0','7','14','1','B','Pure water is neutral, with pH 7.'),
('chemistry','school',9,10,'What is the chemical symbol of sodium?','So','Sd','Na','S','C','Na comes from its Latin name, Natrium.'),
('chemistry','school',9,10,'What is the chemical name of common salt?','Sodium chloride','Sodium carbonate','Calcium chloride','Potassium chloride','A','Common salt is NaCl, sodium chloride.'),
('chemistry','school',9,10,'Which gas is released when zinc reacts with dilute hydrochloric acid?','Oxygen','Chlorine','Carbon dioxide','Hydrogen','D','Zn + 2HCl → ZnCl₂ + H₂.'),
('chemistry','school',9,10,'What is the atomic number of carbon?','12','6','8','14','B','Carbon has 6 protons. 12 is its mass number.'),
('chemistry','school',9,10,'Rusting of iron needs?','Only water','Only oxygen','Both oxygen and water','Nitrogen','C','Iron rusts when exposed to both moist air (oxygen and water).'),
('chemistry','school',9,10,'What is the chemical formula of baking soda?','NaHCO₃','Na₂CO₃','NaCl','NaOH','A','Baking soda is sodium hydrogen carbonate, NaHCO₃.'),
('chemistry','school',9,10,'Which of these is a noble gas?','Nitrogen','Oxygen','Chlorine','Argon','D','Argon is in Group 18 with a complete outer shell.'),

-- ---------------- Biology : Class 9-10 ----------------
('biology','school',9,10,'Which cell organelle contains chlorophyll?','Mitochondria','Chloroplast','Nucleus','Ribosome','B','Chloroplasts contain chlorophyll for photosynthesis.'),
('biology','school',9,10,'What is the functional unit of the kidney?','Nephron','Neuron','Alveolus','Villus','A','Each kidney has about a million nephrons that filter blood.'),
('biology','school',9,10,'Which blood cells fight infection?','Red blood cells','Platelets','White blood cells','Plasma','C','White blood cells are part of the immune system.'),
('biology','school',9,10,'Insulin is produced by which organ?','Liver','Kidney','Thyroid','Pancreas','D','Beta cells in the pancreas make insulin to control blood sugar.'),
('biology','school',9,10,'Who is known as the Father of Genetics?','Charles Darwin','Gregor Mendel','Louis Pasteur','Robert Hooke','B','Mendel discovered the laws of inheritance using pea plants.'),
('biology','school',9,10,'Photosynthesis mainly takes place in which part of a plant?','Roots','Stem','Leaves','Flowers','C','Leaves have the most chloroplasts.'),
('biology','school',9,10,'What is the normal human body temperature?','About 37 °C','About 40 °C','About 32 °C','About 98 °C','A','37 °C is about 98.6 °F.'),
('biology','school',9,10,'Which of these diseases is caused by a virus?','Typhoid','Cholera','Tuberculosis','Measles','D','Measles is viral; the other three are caused by bacteria.'),

-- ---------------- GK : Class 11-12 ----------------
('gk','school',11,12,'Which Article provides for a National Emergency (war, external aggression or armed rebellion)?','Article 356','Article 352','Article 360','Article 370','B','352 = National Emergency, 356 = President''s Rule, 360 = Financial Emergency.'),
('gk','school',11,12,'Who appoints the Chief Justice of India?','The Prime Minister','Parliament','The President','The Law Minister','C','Under Article 124, the President appoints Supreme Court judges.'),
('gk','school',11,12,'What is the minimum age to become President of India?','35 years','30 years','25 years','40 years','A','Article 58 sets the minimum age at 35.'),
('gk','school',11,12,'Who was the first woman Prime Minister of India?','Sarojini Naidu','Pratibha Patil','Sushma Swaraj','Indira Gandhi','D','Indira Gandhi became PM in 1966.'),
('gk','school',11,12,'Members of the Rajya Sabha are elected for how many years?','5','6','4','3','B','Rajya Sabha members serve 6 years; one-third retire every 2 years.'),
('gk','school',11,12,'In which year was GST introduced in India?','2014','2016','2017','2019','C','GST came into effect on 1 July 2017.'),
('gk','school',11,12,'In which year was the Reserve Bank of India established?','1935','1947','1949','1950','A','RBI was set up on 1 April 1935 and nationalised in 1949.'),
('gk','school',11,12,'Which right did Dr. Ambedkar call the "heart and soul" of the Constitution?','Right to Equality','Right to Freedom','Right against Exploitation','Right to Constitutional Remedies','D','Article 32 lets citizens go directly to the Supreme Court.'),

-- ---------------- Current Affairs : Class 11-12 ----------------
('current_affairs','school',11,12,'The three new criminal laws of 2024 replaced which laws?','IPC, CrPC and Indian Evidence Act','IPC, IT Act and RTI Act','CrPC, POCSO and Arms Act','Evidence Act, NDPS Act and IT Act','A','BNS, BNSS and BSA came into force on 1 July 2024.'),
('current_affairs','school',11,12,'ISRO''s SpaDeX mission (January 2025) made India which country to achieve satellite docking?','2nd','3rd','4th','5th','C','After the USA, Russia and China.'),
('current_affairs','school',11,12,'Which is India''s first space-based solar observatory, placed near the Sun-Earth L1 point?','Chandrayaan-3','Aditya-L1','Mangalyaan','AstroSat','B','Aditya-L1 reached its halo orbit around L1 in January 2024.'),
('current_affairs','school',11,12,'How many medals did India win at the Paris 2024 Paralympics, its best-ever haul?','19','22','25','29','D','India won 29 medals: 7 gold, 9 silver and 13 bronze.'),
('current_affairs','school',11,12,'D. Gukesh became World Chess Champion in December 2024 by defeating?','Ding Liren','Magnus Carlsen','Ian Nepomniachtchi','Fabiano Caruana','A','He beat China''s Ding Liren in Singapore.'),
('current_affairs','school',11,12,'Which country hosted the COP28 climate summit in 2023?','Egypt','United Arab Emirates','Brazil','Azerbaijan','B','COP28 was in Dubai; COP29 in Baku (2024); COP30 in Belém, Brazil (2025).'),
('current_affairs','school',11,12,'The ICC Men''s T20 World Cup 2026 is co-hosted by India and?','Bangladesh','Pakistan','Sri Lanka','UAE','C','India and Sri Lanka co-host the 2026 edition.'),
('current_affairs','school',11,12,'In which year did India pass the Digital Personal Data Protection Act?','2019','2021','2022','2023','D','The DPDP Act was passed in August 2023.'),

-- ---------------- Maths : Class 11-12 ----------------
('maths','school',11,12,'What is the derivative of x³?','x²','3x²','3x','x⁴/4','B','d/dx (xⁿ) = n·xⁿ⁻¹, so 3x².'),
('maths','school',11,12,'∫ 2x dx = ?','x² + C','2x² + C','x + C','2 + C','A','The integral of 2x is x² plus a constant.'),
('maths','school',11,12,'How many subsets does a set with 3 elements have?','3','6','8','9','C','A set with n elements has 2ⁿ subsets; 2³ = 8.'),
('maths','school',11,12,'What is the limit of (sin x)/x as x → 0?','0','Infinity','Does not exist','1','D','This is a standard limit equal to 1.'),
('maths','school',11,12,'What is the value of 5! (5 factorial)?','25','120','60','720','B','5 x 4 x 3 x 2 x 1 = 120.'),
('maths','school',11,12,'If A is a 2x3 matrix and B is 3x4, what is the order of AB?','3x3','4x2','2x4','2x3','C','(m x n)(n x p) gives an m x p matrix.'),
('maths','school',11,12,'What is the value of log₁₀ 1000?','3','2','10','100','A','10³ = 1000.'),
('maths','school',11,12,'What is the slope of the line y = 4x - 7?','-7','7','-4','4','D','In y = mx + c, m is the slope.'),

-- ---------------- Physics : Class 11-12 ----------------
('physics','school',11,12,'What is the dimensional formula of force?','[MLT⁻¹]','[MLT⁻²]','[ML²T⁻²]','[M⁰LT⁻²]','B','Force = mass x acceleration = M · LT⁻².'),
('physics','school',11,12,'What is the escape velocity from the Earth''s surface?','About 11.2 km/s','About 9.8 km/s','About 7.9 km/s','About 3 km/s','A','vₑ = √(2gR) ≈ 11.2 km/s. 7.9 km/s is the orbital velocity.'),
('physics','school',11,12,'What is the SI unit of magnetic field?','Weber','Henry','Tesla','Gauss','C','Weber is magnetic flux; Gauss is a CGS unit.'),
('physics','school',11,12,'Who explained the photoelectric effect?','Isaac Newton','Niels Bohr','James Clerk Maxwell','Albert Einstein','D','Einstein won the 1921 Nobel Prize for this work.'),
('physics','school',11,12,'In a series LCR circuit at resonance, the impedance equals?','Zero','R','Infinity','X_L','B','At resonance X_L = X_C, so they cancel and Z = R.'),
('physics','school',11,12,'Which law says the induced current opposes the change that causes it?','Ohm''s law','Coulomb''s law','Lenz''s law','Ampere''s law','C','Lenz''s law follows from conservation of energy.'),
('physics','school',11,12,'Work done in moving a charge on an equipotential surface is?','Zero','Maximum','Infinite','Negative','A','There is no potential difference, so W = qΔV = 0.'),
('physics','school',11,12,'Which device converts AC to DC?','Transistor','Capacitor','Inductor','p-n junction diode (rectifier)','D','A diode allows current in only one direction.'),

-- ---------------- Chemistry : Class 11-12 ----------------
('chemistry','school',11,12,'What is the hybridisation of carbon in methane (CH₄)?','sp','sp³','sp²','dsp²','B','Four bonds pointing to the corners of a tetrahedron: sp³.'),
('chemistry','school',11,12,'What is the IUPAC name of CH₃CH₂OH?','Ethanol','Methanol','Ethanal','Ethanoic acid','A','Two carbons (eth-) with an -OH group (-ol).'),
('chemistry','school',11,12,'What is the value of the Avogadro number?','6.022 x 10²²','3.011 x 10²³','6.022 x 10²³','6.022 x 10²⁴','C','One mole contains 6.022 x 10²³ particles.'),
('chemistry','school',11,12,'Which quantum number gives the shape of an orbital?','Principal','Magnetic','Spin','Azimuthal','D','Azimuthal (l): 0 = s, 1 = p, 2 = d, 3 = f.'),
('chemistry','school',11,12,'The rate of a zero-order reaction is?','Proportional to concentration','Independent of concentration','Proportional to the square of concentration','Inversely proportional to concentration','B','Rate = k[A]⁰ = k.'),
('chemistry','school',11,12,'Which element has the highest electronegativity?','Oxygen','Chlorine','Fluorine','Nitrogen','C','Fluorine is 4.0 on the Pauling scale.'),
('chemistry','school',11,12,'What is the molecular formula of benzene?','C₆H₆','C₆H₁₂','C₆H₁₄','C₅H₅','A','Benzene is a 6-carbon aromatic ring.'),
('chemistry','school',11,12,'Which element is used in the vulcanisation of rubber?','Carbon','Chlorine','Phosphorus','Sulphur','D','Sulphur cross-links rubber chains, making it stronger.'),

-- ---------------- Biology : Class 11-12 ----------------
('biology','school',11,12,'Who proposed the double-helix model of DNA?','Mendel and Morgan','Watson and Crick','Darwin and Wallace','Hershey and Chase','B','Watson and Crick proposed it in 1953.'),
('biology','school',11,12,'Where in the cell are proteins made?','Ribosome','Lysosome','Golgi apparatus','Vacuole','A','Ribosomes translate mRNA into proteins.'),
('biology','school',11,12,'How many chromosomes are there in a human body cell?','23','44','46','48','C','46 chromosomes = 23 pairs.'),
('biology','school',11,12,'Which hormone is called the "emergency hormone"?','Insulin','Thyroxine','Estrogen','Adrenaline','D','Adrenaline prepares the body for fight or flight.'),
('biology','school',11,12,'Which blood group is known as the universal donor?','AB','O','A','B','B','O red cells have no A or B antigens (O-negative is the safest).'),
('biology','school',11,12,'Which enzyme joins DNA fragments in genetic engineering?','Restriction endonuclease','DNA polymerase','DNA ligase','Helicase','C','Ligase is the "molecular glue"; restriction enzymes are the "scissors".'),
('biology','school',11,12,'Which part of the brain controls balance and posture?','Cerebellum','Cerebrum','Medulla oblongata','Hypothalamus','A','The cerebellum coordinates movement and balance.'),
('biology','school',11,12,'In humans, the sex of a child is decided by?','The mother''s X chromosome','Both parents equally','The mother''s diet','The X or Y chromosome from the father','D','The mother always gives an X; the father gives X (girl) or Y (boy).');
