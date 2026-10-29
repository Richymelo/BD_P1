UPDATE AppUser SET isAdmin = 1 WHERE userName = 'Gzuni';
COMMIT;

SELECT id, userName, isAdmin FROM AppUser WHERE userName = 'Gzuni';