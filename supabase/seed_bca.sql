-- =====================================================================
-- PRACTICE QUESTION BANK: BCA (all years share these)
-- Subjects: gk, current_affairs, maths, dbms, java, oops, cpp, cloud,
--           ebusiness, dccn  (8 questions each)
-- Run AFTER phase6_practice.sql. Safe to run again (deletes old rows first).
-- NOTE: Current Affairs questions are as of 2025. Refresh them every year.
-- =====================================================================

delete from public.practice_questions
where education_type = 'college' and course = 'BCA';

insert into public.practice_questions
  (subject, education_type, course,
   question_text, option_a, option_b, option_c, option_d, correct_option, explanation)
values
-- ---------------- GK ----------------
('gk','college','BCA','Who is known as the father of the computer?','Alan Turing','Charles Babbage','John von Neumann','Bill Gates','B','Babbage designed the Analytical Engine in the 1830s.'),
('gk','college','BCA','Where are the headquarters of ISRO?','Bengaluru','Hyderabad','Chennai','Thiruvananthapuram','A','ISRO is headquartered in Bengaluru, Karnataka.'),
('gk','college','BCA','Who co-founded Infosys and was its first CEO?','Azim Premji','Ratan Tata','N. R. Narayana Murthy','Shiv Nadar','C','Infosys was founded in 1981 by Narayana Murthy and six others.'),
('gk','college','BCA','What is the name of India''s first indigenous aircraft carrier?','INS Viraat','INS Vikramaditya','INS Arihant','INS Vikrant','D','INS Vikrant was commissioned in September 2022.'),
('gk','college','BCA','Who invented the World Wide Web?','Vint Cerf','Tim Berners-Lee','Steve Jobs','Larry Page','B','He proposed the WWW at CERN in 1989.'),
('gk','college','BCA','Which body regulates the stock market in India?','RBI','NABARD','SEBI','IRDAI','C','SEBI = Securities and Exchange Board of India.'),
('gk','college','BCA','Which organisation developed and runs UPI?','NPCI','RBI','SBI','NITI Aayog','A','UPI was launched in 2016 by the National Payments Corporation of India.'),
('gk','college','BCA','Which Indian city is called the "Silicon Valley of India"?','Pune','Hyderabad','Chennai','Bengaluru','D','Bengaluru is India''s biggest IT hub.'),

-- ---------------- Current Affairs ----------------
('current_affairs','college','BCA','Which mission, approved in March 2024, aims to build India''s AI computing infrastructure?','IndiaAI Mission','Gaganyaan','Semicon India','Digital India','A','The IndiaAI Mission has an outlay of over ₹10,000 crore.'),
('current_affairs','college','BCA','Tata Electronics is building India''s first commercial semiconductor fab in which state?','Karnataka','Gujarat','Tamil Nadu','Assam','B','The fab is at Dholera, Gujarat (Assam has a chip packaging unit).'),
('current_affairs','college','BCA','In which year did India pass the Digital Personal Data Protection (DPDP) Act?','2019','2021','2023','2024','C','It governs how companies collect and process personal data.'),
('current_affairs','college','BCA','What does ONDC stand for?','Online National Data Centre','Open National Digital Card','Official Network for Data Communication','Open Network for Digital Commerce','D','ONDC lets buyers and sellers on different apps trade with each other.'),
('current_affairs','college','BCA','Which country co-chaired the AI Action Summit with India in February 2025?','United Kingdom','France','USA','Japan','B','The summit was held in Paris.'),
('current_affairs','college','BCA','What is the name of India''s human spaceflight programme?','Chandrayaan','Mangalyaan','Gaganyaan','Shukrayaan','C','Gaganyaan will carry astronauts on ISRO''s LVM3 rocket.'),
('current_affairs','college','BCA','Shubhanshu Shukla flew to the ISS in 2025 on which mission?','Axiom Mission 4','Artemis II','SpaceX Crew-9','Gaganyaan-1','A','Ax-4 launched on a SpaceX Falcon 9 in June 2025.'),
('current_affairs','college','BCA','Who shared the 2024 Nobel Prize in Chemistry with David Baker for AlphaFold?','Geoffrey Hinton and John Hopfield','Yann LeCun and Yoshua Bengio','Sam Altman and Ilya Sutskever','Demis Hassabis and John Jumper','D','AlphaFold predicts protein structures. Hinton and Hopfield won the 2024 Physics prize.'),

-- ---------------- Maths ----------------
('maths','college','BCA','What is decimal 10 in binary?','1001','1010','1100','1110','B','8 + 2 = 10, so 1010.'),
('maths','college','BCA','If A = {1, 2, 3} and B = {2, 3, 4}, what is A ∩ B?','{2, 3}','{1, 4}','{1, 2, 3, 4}','{ }','A','Intersection = elements in both sets.'),
('maths','college','BCA','How many edges does the complete graph K₅ have?','5','20','10','25','C','n(n-1)/2 = 5 x 4 / 2 = 10.'),
('maths','college','BCA','What is the contrapositive of p → q?','q → p','¬p → ¬q','p → ¬q','¬q → ¬p','D','The contrapositive is always logically equivalent to the original.'),
('maths','college','BCA','What is the mean of 2, 4, 6, 8, 10?','5','6','7','8','B','Sum = 30, count = 5, mean = 6.'),
('maths','college','BCA','In how many ways can the letters of "CAT" be arranged?','3','9','6','27','C','3! = 6.'),
('maths','college','BCA','Hexadecimal F equals which decimal number?','15','16','14','10','A','A = 10, B = 11 ... F = 15.'),
('maths','college','BCA','What is the determinant of the matrix [[2, 3], [1, 4]]?','11','8','3','5','D','(2 x 4) - (3 x 1) = 5.'),

-- ---------------- DBMS ----------------
('dbms','college','BCA','Which key uniquely identifies each row in a table?','Foreign key','Primary key','Alternate name','Default value','B','A primary key is unique and not null.'),
('dbms','college','BCA','Which SQL command removes all rows but keeps the table structure, without row-by-row logging?','TRUNCATE','DROP','ALTER','REMOVE','A','DELETE is DML and logs each row; DROP removes the whole table.'),
('dbms','college','BCA','In ACID properties, what does "A" stand for?','Accuracy','Availability','Atomicity','Authorization','C','Atomicity: a transaction happens completely or not at all.'),
('dbms','college','BCA','A table is in 2NF if it is in 1NF and?','Has no multivalued attributes','Has no transitive dependency','Every determinant is a candidate key','Has no partial dependency on the primary key','D','2NF removes partial dependency; 3NF removes transitive dependency.'),
('dbms','college','BCA','Which clause filters groups after GROUP BY?','WHERE','HAVING','ORDER BY','LIMIT','B','WHERE filters rows before grouping; HAVING filters groups.'),
('dbms','college','BCA','What is a foreign key used for?','Speeding up queries','Encrypting data','Enforcing referential integrity between tables','Sorting rows','C','It must match a primary key value in another table (or be null).'),
('dbms','college','BCA','Which JOIN returns only the rows that match in both tables?','INNER JOIN','LEFT JOIN','FULL OUTER JOIN','CROSS JOIN','A','LEFT JOIN also keeps unmatched rows from the left table.'),
('dbms','college','BCA','In an ER diagram, what does a diamond shape represent?','Entity','Attribute','Weak entity','Relationship','D','Rectangle = entity, ellipse = attribute, diamond = relationship.'),

-- ---------------- Java ----------------
('java','college','BCA','Which keyword is used to inherit a class in Java?','implements','extends','inherits','super','B','class B extends A. "implements" is for interfaces.'),
('java','college','BCA','What is the size of an int in Java?','32 bits','16 bits','64 bits','Depends on the OS','A','Java fixes int at 32 bits on every platform.'),
('java','college','BCA','Which method is the entry point of a Java program?','start()','run()','main()','init()','C','public static void main(String[] args).'),
('java','college','BCA','Java source code is compiled into?','Machine code','Assembly code','Source code','Bytecode','D','The JVM runs the bytecode, which makes Java platform-independent.'),
('java','college','BCA','Which collection does NOT allow duplicate elements?','ArrayList','HashSet','LinkedList','Vector','B','A Set stores only unique elements.'),
('java','college','BCA','What is the default value of a boolean instance variable?','true','null','false','0','C','Uninitialised boolean fields default to false.'),
('java','college','BCA','Which keyword stops a method from being overridden?','final','abstract','volatile','transient','A','A final method cannot be overridden by subclasses.'),
('java','college','BCA','Which exception is thrown when an integer is divided by zero?','NullPointerException','IOException','ArrayIndexOutOfBoundsException','ArithmeticException','D','int x = 5 / 0; throws ArithmeticException.'),

-- ---------------- OOPS ----------------
('oops','college','BCA','Wrapping data and methods into a single unit is called?','Inheritance','Encapsulation','Polymorphism','Abstraction','B','A class encapsulates its fields and methods.'),
('oops','college','BCA','Showing only essential features and hiding the details is called?','Abstraction','Encapsulation','Inheritance','Overloading','A','Example: you use a car''s steering without knowing how it works inside.'),
('oops','college','BCA','"One interface, many forms" describes?','Inheritance','Encapsulation','Polymorphism','Composition','C','Poly = many, morph = forms.'),
('oops','college','BCA','A class acquiring the properties of another class is called?','Abstraction','Polymorphism','Encapsulation','Inheritance','D','The child class reuses the parent class''s members.'),
('oops','college','BCA','Method overloading is an example of?','Run-time polymorphism','Compile-time polymorphism','Inheritance','Encapsulation','B','The compiler picks the method by its parameter list. Overriding is run-time.'),
('oops','college','BCA','Which kind of class cannot be instantiated?','Final class','Concrete class','Abstract class','Inner class','C','An abstract class must be extended before you can create objects.'),
('oops','college','BCA','Which special method is called automatically when an object is created?','Constructor','Destructor','Getter','Main method','A','A constructor has the same name as the class and initialises the object.'),
('oops','college','BCA','An "is-a" relationship (e.g. Dog is an Animal) is shown by?','Association','Aggregation','Composition','Inheritance','D','"Has-a" relationships are shown by aggregation or composition.'),

-- ---------------- C++ ----------------
('cpp','college','BCA','Which operator is the scope resolution operator in C++?','.','::','->','#','B','Example: std::cout or ClassName::method().'),
('cpp','college','BCA','Who developed C++?','Bjarne Stroustrup','Dennis Ritchie','James Gosling','Guido van Rossum','A','He created "C with Classes" in 1979, renamed C++ in 1983.'),
('cpp','college','BCA','Which object is used to print output in C++?','cin','scanf','cout','getline','C','cout << "Hello"; cin is for input.'),
('cpp','college','BCA','Which keyword lets a function be overridden and called through a base-class pointer?','static','inline','friend','virtual','D','Virtual functions enable run-time polymorphism.'),
('cpp','college','BCA','What is the destructor of class Box called?','Box()','~Box()','delete Box()','!Box()','B','A destructor is the class name prefixed with a tilde (~).'),
('cpp','college','BCA','Which operator allocates memory dynamically in C++?','alloc','create','new','make','C','new allocates memory and delete frees it.'),
('cpp','college','BCA','What is the default access specifier for members of a class in C++?','private','public','protected','internal','A','In a struct the default is public.'),
('cpp','college','BCA','A non-member function that can access private members of a class is a?','Static function','Inline function','Virtual function','Friend function','D','It is declared inside the class with the keyword friend.'),

-- ---------------- Cloud Computing ----------------
('cloud','college','BCA','What does IaaS stand for?','Internet as a Service','Infrastructure as a Service','Integration as a Service','Information as a Service','B','IaaS provides virtual machines, storage and networks.'),
('cloud','college','BCA','Gmail is an example of which cloud service model?','SaaS','PaaS','IaaS','DaaS','A','Software as a Service: you just use the app in a browser.'),
('cloud','college','BCA','A deployment that combines a private cloud with a public cloud is called?','Public cloud','Private cloud','Hybrid cloud','Community cloud','C','Hybrid clouds keep sensitive data private and use the public cloud for scale.'),
('cloud','college','BCA','What does Amazon EC2 provide?','Storage buckets','DNS service','Email service','Virtual servers','D','EC2 = Elastic Compute Cloud. S3 provides storage.'),
('cloud','college','BCA','What does "pay-as-you-go" pricing mean?','A fixed yearly fee','You pay only for what you use','It is free forever','You buy the hardware first','B','You are billed by usage, for example per hour or per GB.'),
('cloud','college','BCA','Adding or removing servers automatically based on load is called?','Virtualisation','Replication','Auto-scaling','Caching','C','Auto-scaling gives elasticity, a key cloud feature.'),
('cloud','college','BCA','Which software creates and runs virtual machines?','Hypervisor','Compiler','Firewall','Router','A','Examples: VMware ESXi, Hyper-V, KVM.'),
('cloud','college','BCA','Which of these is a PaaS (Platform as a Service)?','Microsoft Word','Amazon EC2','Dropbox','Google App Engine','D','You deploy code and the platform runs it. EC2 is IaaS; Dropbox is SaaS.'),

-- ---------------- E-Business ----------------
('ebusiness','college','BCA','What does B2C stand for?','Business to Company','Business to Consumer','Buyer to Customer','Bank to Consumer','B','A business sells directly to individual customers.'),
('ebusiness','college','BCA','Flipkart selling products to shoppers is an example of?','B2C','B2B','C2C','G2C','A','A business selling to consumers.'),
('ebusiness','college','BCA','OLX, where individuals sell to other individuals, is an example of?','B2B','B2C','C2C','B2G','C','Consumer to Consumer.'),
('ebusiness','college','BCA','Which protocol secures online payment pages (the padlock icon)?','FTP','SMTP','HTTP','HTTPS','D','HTTPS encrypts data using SSL/TLS.'),
('ebusiness','college','BCA','What does EDI stand for?','Electronic Data Internet','Electronic Data Interchange','Easy Digital Invoice','Enterprise Data Integration','B','EDI lets companies exchange business documents electronically.'),
('ebusiness','college','BCA','Which of these is a digital wallet?','MS Excel','Google Chrome','Paytm','Zoom','C','Digital wallets store money and make online payments.'),
('ebusiness','college','BCA','What does a payment gateway do?','Securely processes online payments between customer, merchant and bank','Designs the website','Delivers products','Hosts the database','A','Examples: Razorpay, PayU, CCAvenue.'),
('ebusiness','college','BCA','Which portal does the Government of India use for online public procurement?','IRCTC','DigiLocker','UMANG','GeM','D','GeM = Government e-Marketplace.'),

-- ---------------- Data Communication & Computer Networks ----------------
('dccn','college','BCA','How many layers does the OSI model have?','5','7','4','6','B','Physical, Data Link, Network, Transport, Session, Presentation, Application.'),
('dccn','college','BCA','Which OSI layer is responsible for routing?','Network layer','Transport layer','Data link layer','Session layer','A','Routers work at the network layer using IP addresses.'),
('dccn','college','BCA','Which device forwards frames using MAC addresses at the data link layer?','Hub','Router','Switch','Repeater','C','A hub just repeats signals; a router uses IP addresses.'),
('dccn','college','BCA','What is the size of an IPv4 address?','16 bits','64 bits','128 bits','32 bits','D','IPv4 is 32 bits; IPv6 is 128 bits.'),
('dccn','college','BCA','Which protocol is connection-oriented and reliable?','UDP','TCP','IP','ICMP','B','TCP uses a 3-way handshake, acknowledgements and retransmission.'),
('dccn','college','BCA','What is the default port number for HTTP?','21','443','80','25','C','FTP = 21, SMTP = 25, HTTPS = 443.'),
('dccn','college','BCA','In which topology are all devices connected to a central hub or switch?','Star','Ring','Bus','Mesh','A','If the central device fails, the whole network goes down.'),
('dccn','college','BCA','What does DNS do?','Converts IP addresses to MAC addresses','Converts MAC addresses to IP addresses','Sends email','Translates domain names into IP addresses','D','DNS is like the phone book of the internet.');
