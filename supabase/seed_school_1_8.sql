-- =====================================================================
-- PRACTICE QUESTION BANK: Class 1 to 8
-- Subjects: gk, current_affairs, maths, science
-- Bands: Class 1-2, Class 3-5, Class 6-8 (each band = 8 questions/subject)
-- Run AFTER phase6_practice.sql. Safe to run again (deletes old rows first).
-- NOTE: Current Affairs questions are as of 2025. Check and refresh them
--       every year.
-- =====================================================================

delete from public.practice_questions
where education_type = 'school' and max_standard <= 8;

insert into public.practice_questions
  (subject, education_type, min_standard, max_standard,
   question_text, option_a, option_b, option_c, option_d, correct_option, explanation)
values
-- ---------------- GK : Class 1-2 ----------------
('gk','school',1,2,'How many days are there in a week?','5','6','7','8','C','A week has 7 days, from Monday to Sunday.'),
('gk','school',1,2,'Which animal is called the King of the Jungle?','Elephant','Lion','Tiger','Bear','B','The lion is called the King of the Jungle.'),
('gk','school',1,2,'What colour is the sky on a clear day?','Blue','Green','Red','Black','A','On a clear day the sky looks blue.'),
('gk','school',1,2,'Which is the national bird of India?','Parrot','Sparrow','Crow','Peacock','D','The peacock is the national bird of India.'),
('gk','school',1,2,'How many legs does a spider have?','6','8','4','10','B','A spider has 8 legs. Insects have 6.'),
('gk','school',1,2,'Which fruit is called the King of Fruits?','Apple','Banana','Mango','Grapes','C','The mango is called the King of Fruits.'),
('gk','school',1,2,'Which festival is known as the festival of lights?','Diwali','Holi','Eid','Christmas','A','Diwali is the festival of lights; people light diyas.'),
('gk','school',1,2,'In which direction does the Sun rise?','West','North','South','East','D','The Sun rises in the East and sets in the West.'),

-- ---------------- Current Affairs : Class 1-2 ----------------
('current_affairs','school',1,2,'Who is the President of India?','Droupadi Murmu','Narendra Modi','Amit Shah','Rahul Gandhi','A','Droupadi Murmu became the President of India in July 2022.'),
('current_affairs','school',1,2,'Who is the Prime Minister of India?','Amit Shah','Narendra Modi','Droupadi Murmu','Rajnath Singh','B','Narendra Modi is the Prime Minister of India.'),
('current_affairs','school',1,2,'Which country won the Men''s T20 Cricket World Cup in 2024?','Australia','England','India','Pakistan','C','India won the T20 World Cup in 2024.'),
('current_affairs','school',1,2,'Chandrayaan-3 was sent by India to which place?','Mars','Sun','Venus','Moon','D','Chandrayaan-3 landed on the Moon in August 2023.'),
('current_affairs','school',1,2,'Which Indian space agency sent Chandrayaan-3?','NASA','ISRO','ESA','JAXA','B','ISRO is the Indian Space Research Organisation.'),
('current_affairs','school',1,2,'Which city hosted the Olympic Games in 2024?','Paris','Tokyo','London','Delhi','A','The 2024 Summer Olympics were held in Paris, France.'),
('current_affairs','school',1,2,'In 2024, D. Gukesh of India became world champion in which game?','Cricket','Chess','Badminton','Football','B','Gukesh became the youngest World Chess Champion in December 2024.'),
('current_affairs','school',1,2,'Which Indian astronaut went to the International Space Station in 2025?','Rakesh Sharma','Kalpana Chawla','Shubhanshu Shukla','Sunita Williams','C','Shubhanshu Shukla went to the ISS in June 2025 on the Axiom-4 mission.'),

-- ---------------- Maths : Class 1-2 ----------------
('maths','school',1,2,'5 + 3 = ?','7','8','9','6','B','5 + 3 = 8.'),
('maths','school',1,2,'10 - 4 = ?','5','7','6','4','C','10 - 4 = 6.'),
('maths','school',1,2,'Which number comes just after 19?','18','21','29','20','D','After 19 comes 20.'),
('maths','school',1,2,'How many sides does a triangle have?','3','4','5','6','A','A triangle has 3 sides.'),
('maths','school',1,2,'2 x 5 = ?','7','10','12','25','B','2 groups of 5 make 10.'),
('maths','school',1,2,'Which is the biggest number?','45','39','50','54','D','54 is bigger than 50, 45 and 39.'),
('maths','school',1,2,'How many tens are there in 70?','7','70','10','17','A','70 = 7 tens.'),
('maths','school',1,2,'What is half of 10?','2','5','20','4','B','10 split into 2 equal parts gives 5 each.'),

-- ---------------- Science : Class 1-2 ----------------
('science','school',1,2,'Which part of a plant grows under the soil?','Leaf','Flower','Root','Fruit','C','Roots grow under the soil and take in water.'),
('science','school',1,2,'Which of these is a living thing?','Stone','Dog','Chair','Pen','B','A dog breathes, eats and grows, so it is living.'),
('science','school',1,2,'Which gas do we breathe in to stay alive?','Oxygen','Smoke','Carbon dioxide','Steam','A','We breathe in oxygen and breathe out carbon dioxide.'),
('science','school',1,2,'Which sense organ helps us to see?','Nose','Ear','Tongue','Eyes','D','We see with our eyes.'),
('science','school',1,2,'Ice is which form of water?','Liquid','Solid','Gas','None of these','B','Ice is the solid form of water.'),
('science','school',1,2,'Which animal gives us milk?','Cow','Hen','Fish','Frog','A','Cows give us milk. Hens give eggs.'),
('science','school',1,2,'Plants make their food with the help of?','Moonlight','Sunlight','Darkness','Wind','B','Plants use sunlight to make food in their leaves.'),
('science','school',1,2,'Which of these gives us light?','Table','Book','Mirror','Sun','D','The Sun is a natural source of light.'),

-- ---------------- GK : Class 3-5 ----------------
('gk','school',3,5,'What is the capital of India?','Mumbai','Kolkata','New Delhi','Chennai','C','New Delhi is the capital of India.'),
('gk','school',3,5,'Which is the largest planet in our solar system?','Earth','Jupiter','Saturn','Mars','B','Jupiter is the largest planet.'),
('gk','school',3,5,'Who wrote India''s national anthem "Jana Gana Mana"?','Rabindranath Tagore','Bankim Chandra Chatterjee','Sarojini Naidu','Mahatma Gandhi','A','Rabindranath Tagore wrote Jana Gana Mana.'),
('gk','school',3,5,'Which is the longest river in India?','Yamuna','Godavari','Narmada','Ganga','D','The Ganga is the longest river flowing in India.'),
('gk','school',3,5,'How many states are there in India?','26','28','29','30','B','India has 28 states and 8 union territories.'),
('gk','school',3,5,'Which is the national animal of India?','Lion','Elephant','Tiger','Peacock','C','The Bengal tiger is the national animal of India.'),
('gk','school',3,5,'Which is the largest ocean in the world?','Atlantic Ocean','Indian Ocean','Arctic Ocean','Pacific Ocean','D','The Pacific Ocean is the largest and deepest ocean.'),
('gk','school',3,5,'Who is called the Father of the Nation in India?','Jawaharlal Nehru','Mahatma Gandhi','Bhagat Singh','Subhas Chandra Bose','B','Mahatma Gandhi is called the Father of the Nation.'),

-- ---------------- Current Affairs : Class 3-5 ----------------
('current_affairs','school',3,5,'Chandrayaan-3 landed near which part of the Moon in August 2023?','North pole','South pole','Equator','The middle of the far side','B','India became the first country to land near the Moon''s south pole.'),
('current_affairs','school',3,5,'India celebrates 23 August as which day?','National Space Day','National Science Day','Engineers Day','Children''s Day','A','23 August marks the Chandrayaan-3 landing (2023).'),
('current_affairs','school',3,5,'Aditya-L1 is India''s first mission to study the?','Moon','Mars','Sun','Venus','C','Aditya-L1, launched in 2023, studies the Sun.'),
('current_affairs','school',3,5,'In March 2025, India beat New Zealand in the final to win which cricket trophy?','Asia Cup','Champions Trophy','World Test Championship','T20 World Cup','B','India won the ICC Champions Trophy 2025.'),
('current_affairs','school',3,5,'Which Indian shooter won two bronze medals at the Paris Olympics 2024?','Mary Kom','P. V. Sindhu','Mirabai Chanu','Manu Bhaker','D','Manu Bhaker won two bronze medals in shooting.'),
('current_affairs','school',3,5,'The Maha Kumbh Mela 2025 was held in which city?','Haridwar','Prayagraj','Ujjain','Nashik','B','The Maha Kumbh 2025 was held in Prayagraj, Uttar Pradesh.'),
('current_affairs','school',3,5,'In which city was the G20 Leaders'' Summit held in September 2023?','New Delhi','Mumbai','Bengaluru','Goa','A','India hosted the G20 Summit at Bharat Mandapam, New Delhi.'),
('current_affairs','school',3,5,'In January 2024, the Ram Mandir was inaugurated in which city?','Varanasi','Mathura','Ayodhya','Ujjain','C','The Ram Mandir in Ayodhya was consecrated on 22 January 2024.'),

-- ---------------- Maths : Class 3-5 ----------------
('maths','school',3,5,'25 x 4 = ?','100','90','120','75','A','25 x 4 = 100.'),
('maths','school',3,5,'144 / 12 = ?','11','14','12','10','C','12 x 12 = 144, so 144 / 12 = 12.'),
('maths','school',3,5,'What is 1/2 + 1/4?','2/6','3/4','1/6','1/8','B','1/2 = 2/4, and 2/4 + 1/4 = 3/4.'),
('maths','school',3,5,'How many minutes are there in 2 hours?','100','60','200','120','D','1 hour = 60 minutes, so 2 hours = 120 minutes.'),
('maths','school',3,5,'What is the perimeter of a square with side 5 cm?','10 cm','20 cm','25 cm','15 cm','B','Perimeter = 4 x side = 4 x 5 = 20 cm.'),
('maths','school',3,5,'Which of these is a prime number?','9','15','13','21','C','13 can only be divided by 1 and 13.'),
('maths','school',3,5,'What is the Roman numeral for 50?','X','L','C','D','B','L = 50, X = 10, C = 100, D = 500.'),
('maths','school',3,5,'What is the place value of 7 in 4,732?','7','70','7000','700','D','7 is in the hundreds place, so its value is 700.'),

-- ---------------- Science : Class 3-5 ----------------
('science','school',3,5,'Which planet is known as the Red Planet?','Venus','Mars','Jupiter','Mercury','B','Mars looks red because of iron oxide (rust) on its surface.'),
('science','school',3,5,'Which organ pumps blood through our body?','Lungs','Brain','Heart','Liver','C','The heart pumps blood to all parts of the body.'),
('science','school',3,5,'At what temperature does water boil (at sea level)?','100 °C','50 °C','0 °C','200 °C','A','Water boils at 100 °C and freezes at 0 °C.'),
('science','school',3,5,'Which gas do plants take in to make their food?','Oxygen','Nitrogen','Hydrogen','Carbon dioxide','D','Plants use carbon dioxide, water and sunlight to make food.'),
('science','school',3,5,'Which of these animals is a herbivore?','Lion','Cow','Tiger','Wolf','B','A herbivore eats only plants. Cows eat grass.'),
('science','school',3,5,'Water changing into water vapour is called?','Condensation','Freezing','Evaporation','Melting','C','Evaporation turns liquid water into vapour.'),
('science','school',3,5,'Which organ helps us to breathe?','Stomach','Lungs','Kidney','Heart','B','We breathe with our lungs.'),
('science','school',3,5,'Which of these is a natural magnet?','Lodestone','Iron nail','Copper wire','Plastic','A','Lodestone is a naturally magnetic rock.'),

-- ---------------- GK : Class 6-8 ----------------
('gk','school',6,8,'Who was the first Prime Minister of India?','Jawaharlal Nehru','Sardar Patel','Rajendra Prasad','Indira Gandhi','A','Jawaharlal Nehru was PM from 1947 to 1964.'),
('gk','school',6,8,'Who was the first President of India?','S. Radhakrishnan','Rajendra Prasad','Zakir Husain','A. P. J. Abdul Kalam','B','Dr. Rajendra Prasad was the first President (1950-1962).'),
('gk','school',6,8,'On which date did the Constitution of India come into force?','26 November 1949','15 August 1947','26 January 1950','2 October 1950','C','It came into force on 26 January 1950, celebrated as Republic Day.'),
('gk','school',6,8,'Which is the smallest state of India by area?','Sikkim','Tripura','Manipur','Goa','D','Goa is the smallest Indian state by area.'),
('gk','school',6,8,'Where is the headquarters of the United Nations?','Geneva','New York','Paris','London','B','The UN headquarters is in New York, USA.'),
('gk','school',6,8,'Which is the highest mountain peak in the world?','K2','Kangchenjunga','Mount Everest','Nanda Devi','C','Mount Everest is about 8,849 m high.'),
('gk','school',6,8,'Which instrument is used to record earthquakes?','Barometer','Thermometer','Hygrometer','Seismograph','D','A seismograph records earthquake waves.'),
('gk','school',6,8,'Who is known as the "Missile Man of India"?','A. P. J. Abdul Kalam','Homi Bhabha','Vikram Sarabhai','C. V. Raman','A','Dr. Kalam led India''s missile programmes.'),

-- ---------------- Current Affairs : Class 6-8 ----------------
('current_affairs','school',6,8,'In June 2025, Shubhanshu Shukla became the first Indian to visit which place?','The Moon','The International Space Station','Mars orbit','China''s space station','B','He flew to the ISS on the Axiom-4 mission.'),
('current_affairs','school',6,8,'What did ISRO''s SpaDeX mission demonstrate in January 2025?','Docking two satellites in space','Landing on Mars','A Moon rover','A reusable rocket','A','India became the 4th country, after the USA, Russia and China, to dock satellites in space.'),
('current_affairs','school',6,8,'Who became the youngest-ever World Chess Champion in December 2024?','Magnus Carlsen','Viswanathan Anand','R. Praggnanandhaa','D. Gukesh','D','Gukesh won the title at age 18 by beating Ding Liren.'),
('current_affairs','school',6,8,'Which medal did Neeraj Chopra win in javelin at the Paris Olympics 2024?','Gold','Silver','Bronze','No medal','B','He won silver; he had won gold at Tokyo 2020.'),
('current_affairs','school',6,8,'The Bharatiya Nyaya Sanhita, which replaced the Indian Penal Code, came into force on?','1 January 2024','15 August 2024','1 July 2024','26 January 2025','C','The three new criminal laws came into force on 1 July 2024.'),
('current_affairs','school',6,8,'Who was sworn in as Prime Minister of India for a third term in June 2024?','Narendra Modi','Rajnath Singh','Amit Shah','Nitin Gadkari','A','Narendra Modi began his third consecutive term in June 2024.'),
('current_affairs','school',6,8,'Who became the 47th President of the United States in January 2025?','Joe Biden','Kamala Harris','Donald Trump','Barack Obama','C','Donald Trump returned as President in January 2025.'),
('current_affairs','school',6,8,'What was the theme of India''s G20 presidency in 2023?','Make in India','Digital India','Swachh Bharat','Vasudhaiva Kutumbakam: One Earth, One Family, One Future','D','The theme came from the Sanskrit phrase meaning "the world is one family".'),

-- ---------------- Maths : Class 6-8 ----------------
('maths','school',6,8,'What is the value of 3² + 4²?','25','49','12','14','A','9 + 16 = 25.'),
('maths','school',6,8,'What is the LCM of 4 and 6?','24','12','2','10','B','Multiples of 4: 4, 8, 12. Multiples of 6: 6, 12. Smallest common = 12.'),
('maths','school',6,8,'Solve: 2x + 5 = 15. What is x?','10','7.5','5','4','C','2x = 10, so x = 5.'),
('maths','school',6,8,'What is the sum of the angles of a triangle?','90°','360°','270°','180°','D','The three angles of any triangle add up to 180°.'),
('maths','school',6,8,'What is 20% of 250?','25','50','20','75','B','20/100 x 250 = 50.'),
('maths','school',6,8,'What is the area of a rectangle 8 cm long and 5 cm wide?','13 cm²','26 cm²','40 cm²','45 cm²','C','Area = length x breadth = 8 x 5 = 40 cm².'),
('maths','school',6,8,'What is the square root of 169?','12','13','14','17','B','13 x 13 = 169.'),
('maths','school',6,8,'(-3) x (-4) = ?','12','-12','7','-7','A','A negative times a negative gives a positive.'),

-- ---------------- Science : Class 6-8 ----------------
('science','school',6,8,'What is the basic unit of life?','Atom','Cell','Tissue','Organ','B','All living things are made of cells.'),
('science','school',6,8,'What is the chemical formula of water?','H2O','CO2','O2','NaCl','A','Water has 2 hydrogen atoms and 1 oxygen atom.'),
('science','school',6,8,'Which vitamin does our skin make in sunlight?','Vitamin A','Vitamin C','Vitamin D','Vitamin K','C','Sunlight helps the skin make Vitamin D.'),
('science','school',6,8,'What is the SI unit of force?','Joule','Watt','Pascal','Newton','D','Force is measured in newtons (N).'),
('science','school',6,8,'Which part of the cell is called its powerhouse?','Nucleus','Mitochondria','Ribosome','Cell wall','B','Mitochondria release energy from food.'),
('science','school',6,8,'What is the approximate speed of light?','3 x 10^5 m/s','3 x 10^6 m/s','3 x 10^8 m/s','3 x 10^10 m/s','C','Light travels about 3,00,000 km every second.'),
('science','school',6,8,'Which acid is found in lemons?','Acetic acid','Lactic acid','Hydrochloric acid','Citric acid','D','Citrus fruits contain citric acid.'),
('science','school',6,8,'Lack of iodine in the diet causes which disease?','Goitre','Scurvy','Rickets','Night blindness','A','Iodine is needed by the thyroid gland; lack of it causes goitre.');
