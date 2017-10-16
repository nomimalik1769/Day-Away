//
//  DBManager.swift
//  FMDBTut
//
//  Created by Gabriel Theodoropoulos on 07/10/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

import UIKit

public class DBManager: NSObject {

    
    
    static let shared: DBManager = DBManager()
    
    let databaseFileName = "Contactss.sqlite"
    
    var pathToDatabase: String!
    
    var database: FMDatabase!
    
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
        print(pathToDatabase)
    }
    
    
    
    func createDatabase() -> Bool {
        var created = false
        
        if !FileManager.default.fileExists(atPath: pathToDatabase) {
            database = FMDatabase(path: pathToDatabase!)
            
            //if database != nil {
                // Open the database.
                if database.open() {
                    
                    
                    
                    
                    do {
                        try database.executeUpdate("create table ContactsDetails(C_Name text not null, C_Number text not null)", values: nil)
                        created = true
                    }
                    catch {
                        print("Could not create table.")
                        print(error.localizedDescription)
                    }
                    
                    
//                }
//                else {
//                    print("Could not open the database.")
//                }
            
            do{
                
            
            try database.executeUpdate("create table blockonoff(flagg text not null)", values: nil)
            }
            catch
            {
                print(error.localizedDescription)
            }
            database.close()
            }
        }
        
        return created
    }
    
    
    func openDatabase() -> Bool {
        if database == nil {
            if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
                print("nil database")
            }
        }
        
        if database != nil {
            if database.open() {
                print(pathToDatabase)
                print("open ")
                return true
            }
        }
        print("close ")
        return false
    }
    
    func insrtintoblock()
    {
        if openDatabase()
        {
            if database.tableExists("blockonoff")
            {
                do
                {
                    try database.executeUpdate("insert into blockonoff(flagg) values(off)", values:nil)
                }
                catch
                {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func selectblockonoff() -> String
    {
        var flag = String()
     
        if openDatabase()
        {
            do
            {
                let res = try database.executeQuery("select * from blockonoff", values: nil)
                if res.next()
                {
                flag = res.string(forColumn: "flagg")
                }
                else
                {
                    flag = "off"
                }
            }
            catch
            {
                print(error.localizedDescription)
            }
            
            
        }
        return flag
    }
    
    func updateonoff(lbl: String)
    {
        if openDatabase()
        {
            do
            {
                try database.executeUpdate("update blockonoff set flagg = ?", values: [lbl])
            }
            catch
            {
                
            }
        }
    }
    
    
    
    func insertContact(name: String, number: Int)
   {
    if openDatabase()
    {
        if database.tableExists("ContactsDetails")
        {
         //   let query = "insert into ContactsDetails(C_Name, C_Number) values(?,?)"
            
            do
            {
                print(name)
                print(number)
                try database.executeUpdate("insert into ContactsDetails(C_Name, C_Number) values(?,?)", values: [name,number])
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        else
        {
            print("Table Not Found ")
        }
    }
    else
    {
        print("Database Not Open")
    }
    
    
}
    
func selectContacts() -> [Int64]
{   var numbers = [Int64]()
    
    
    
    if openDatabase()
    {
        if database.tableExists("ContactsDetails")
        {
            do
            {
                let res = try database.executeQuery("select * from ContactsDetails", values: nil)
                while res.next()
                {
                
                print(res.string(forColumn: "C_Number"))
                if res.string(forColumn: "C_Number") != nil
                {
                    numbers.append(Int64(res.string(forColumn: "C_Number"))!)
                }
                }
                
            }
            catch
            {
                
            }
        }
    
    }
    
    return numbers
}
    
    func selectContactsname() -> [String]
    {   var numbers = [String]()
        
        if openDatabase()
        {
            if database.tableExists("ContactsDetails")
            {
                do
                {
                    let res = try database.executeQuery("select * from ContactsDetails", values: nil)
                    print(res.string(forColumn: "C_Name"))
                    
                    while res.next()
                    {
                    if res.string(forColumn: "C_Name") != nil
                    {
                    numbers.append(res.string(forColumn: "C_Name"))
                    }
                    }
                    
                    
                }
                catch
                {
                    
                }
            }
            
        }
        
        return numbers
    }
    
    
    
    
//    func insertMovieData() {
//        if openDatabase() {
//            if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
//                do {
//                    let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
//
//                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
//
//                    var query = ""
//                    for movie in moviesData {
//                        let movieParts = movie.components(separatedBy: "\t")
//
//                        if movieParts.count == 5 {
//                            let movieTitle = movieParts[0]
//                            let movieCategory = movieParts[1]
//                            let movieYear = movieParts[2]
//                            let movieURL = movieParts[3]
//                            let movieCoverURL = movieParts[4]
//
//                            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
//                        }
//                    }
//
//                    if !database.executeStatements(query) {
//                        print("Failed to insert initial data into the database.")
//                        print(database.lastError(), database.lastErrorMessage())
//                    }
//                }
//                catch {
//                    print(error.localizedDescription)
//                }
//            }
//
//            database.close()
//        }
//    }
//
//
//    func loadMovies() -> [MovieInfo]! {
//        var movies: [MovieInfo]!
//
//        if openDatabase() {
//            let query = "select * from movies order by \(field_MovieYear) asc"
//
//            do {
//                print(database)
//                let results = try database.executeQuery(query, values: nil)
//
//                while results.next() {
//                    let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
//                                          title: results.string(forColumn: field_MovieTitle),
//                                          category: results.string(forColumn: field_MovieCategory),
//                                          year: Int(results.int(forColumn: field_MovieYear)),
//                                          movieURL: results.string(forColumn: field_MovieURL),
//                                          coverURL: results.string(forColumn: field_MovieCoverURL),
//                                          watched: results.bool(forColumn: field_MovieWatched),
//                                          likes: Int(results.int(forColumn: field_MovieLikes))
//                    )
//
//                    if movies == nil {
//                        movies = [MovieInfo]()
//                    }
//
//                    movies.append(movie)
//                }
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//
//            database.close()
//        }
//
//        return movies
//    }
//
    
//    func loadMovie(withID ID: Int, completionHandler: (_ movieInfo: MovieInfo?) -> Void) {
//        var movieInfo: MovieInfo!
//
//        if openDatabase() {
//            let query = "select * from movies where \(field_MovieID)=?"
//
//            do {
//                let results = try database.executeQuery(query, values: [ID])
//
//                if results.next() {
//                    movieInfo = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
//                                          title: results.string(forColumn: field_MovieTitle),
//                                          category: results.string(forColumn: field_MovieCategory),
//                                          year: Int(results.int(forColumn: field_MovieYear)),
//                                          movieURL: results.string(forColumn: field_MovieURL),
//                                          coverURL: results.string(forColumn: field_MovieCoverURL),
//                                          watched: results.bool(forColumn: field_MovieWatched),
//                                          likes: Int(results.int(forColumn: field_MovieLikes))
//                    )
//
//                }
//                else {
//                    print(database.lastError())
//                }
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//
//            database.close()
//        }
//
//        completionHandler(movieInfo)
//    }
//
    
//    func updateMovie(withID ID: Int, watched: Bool, likes: Int) {
//        if openDatabase() {
//            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
//
//            do {
//                try database.executeUpdate(query, values: [watched, likes, ID])
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//
//            database.close()
//        }
//    }
//
//
//    func deleteMovie(withID ID: Int) -> Bool {
//        var deleted = false
//
//        if openDatabase() {
//            let query = "delete from movies where \(field_MovieID)=?"
//
//            do {
//                try database.executeUpdate(query, values: [ID])
//                deleted = true
//            }
//            catch {
//                print(error.localizedDescription)
//            }
//
//            database.close()
//        }
//
//        return deleted
//    }
//
}
