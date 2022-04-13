Matthew Liu, mliu78
Karen He, khe8

For many of the tables, additional attributes were added with fabricated data. The decision for this was made after talking to our CA mentor and getting the green light to do this to increase data complexity and make for more interesting interactions between tables. The fabricated attributes were described in process.txt.

A challenge that we ran into was that we had tricky foreign key errors. Logically, our implementation for foreign keys in our startup scripts when creating tables makes sense, but when running it, foreign key errors related to Patient_Ledger type_of foreign key occurred. We've brought this up with our CA mentor and visited one of the CA OH to try to resolve this issue, but have been unsuccessful. Thus, we've decided to remove the type_of foreign key from our startup scripts for Patient_Ledger.