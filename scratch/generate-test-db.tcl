source ../repository.tcl

::repo::create

sqlite3 db ./data/repo.sqlite -create false

set conflictAlgorithm abort
set columnSeparator |

db copy $conflictAlgorithm uploads dummy-files.csv $columnSeparator

db copy $conflictAlgorithm programs dummy-programs.csv $columnSeparator

db eval {delete from uploads where id = 0; delete from programs where id = 0}
