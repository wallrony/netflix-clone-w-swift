//
//  TitleViewModel.swift
//  netflix-clone
//
//  Created by Rony on 18/11/22.
//

import UIKit
import Combine

class TitleViewModel: ObservableObject {
    @Published var trendingMovies: [Movie]?
    @Published var popularMovies: [Movie]?
    @Published var upcomingMovies: [Movie]?
    @Published var topratedMovies: [Movie]?
    @Published var trendingTvs: [TV]?
    @Published var discoverMovies: [Movie]?
    @Published var searchedMovies: [Movie]?
    
    private var subscriptions = Set<AnyCancellable>()
    
    var trendingMoviesPublisher: Published<[Movie]?>.Publisher {
        return $trendingMovies
    }
    var popularMoviesPublisher: Published<[Movie]?>.Publisher {
        return $popularMovies
    }
    var upcomingMoviesPublisher: Published<[Movie]?>.Publisher {
        return $upcomingMovies
    }
    var topratedMoviesPublisher: Published<[Movie]?>.Publisher {
        return $topratedMovies
    }
    var trendingTvsPublisher: Published<[TV]?>.Publisher {
        return $trendingTvs
    }
    var discoverMoviesPublisher: Published<[Movie]?>.Publisher {
        return $discoverMovies
    }
    var searchedMoviesPublisher: Published<[Movie]?>.Publisher {
        return $searchedMovies
    }
    
    private var moviesService: MoviesUseCase
    private var tvService: TVUseCase
    
    init(moviesService: MoviesUseCase, tvService: TVUseCase) {
        self.moviesService = moviesService
        self.tvService = tvService
    }
    
    func fillTableViewCellSection(section: TitleSection, cell: UITableViewCell) -> UITableViewCell {
        let titlesCount = self.getTitlesByClassification(section.classification)?.count ?? 0
        if titlesCount > 0 {
            return cell
        }
        guard let customCell = cell as? TitleCollectionViewTableViewCell else {
            return cell
        }
        if section.type == TitleType.Movie {
            if let moviesPublisher = self.getMoviePublisherByClassification(section.classification) {
                moviesPublisher.sink(receiveValue: { movies in
                    if movies != nil {
                        customCell.configure(with: movies!.map(Title.Movie))
                    } else {
                        self.fetchTitlesByClassification(section.classification)
                    }
                }).store(in: &subscriptions)
            }
        } else if section.type == TitleType.TV {
            if let tvsPublisher = self.getTVPublisherByClassification(section.classification) {
                tvsPublisher.sink(receiveValue: { tvs in
                    if tvs != nil {
                        customCell.configure(with: tvs!.map(Title.TV))
                    } else {
                        self.fetchTitlesByClassification(section.classification)
                    }
                }).store(in: &subscriptions)
            }
        }
        return customCell
    }
    
    func fillTableViewCell(section: TitleSection, cell: TitleTableViewCell, index: Int) -> UITableViewCell {
        let titlesCount = self.getTitlesByClassification(section.classification)?.count ?? 0
        if titlesCount > 0 {
            return cell
        }
        if section.type == TitleType.Movie {
            if let moviesPublisher = self.getMoviePublisherByClassification(section.classification) {
                moviesPublisher.sink(receiveValue: { movies in
                    if movies != nil {
                        cell.configure(with: movies!.map(Title.Movie)[index])
                    } else {
                        self.fetchTitlesByClassification(section.classification)
                    }
                }).store(in: &subscriptions)
            }
        } else if section.type == TitleType.TV {
            if let tvsPublisher = self.getTVPublisherByClassification(section.classification) {
                tvsPublisher.sink(receiveValue: { tvs in
                    if tvs != nil {
                        cell.configure(with: tvs!.map(Title.TV)[index])
                    } else {
                        self.fetchTitlesByClassification(section.classification)
                    }
                }).store(in: &subscriptions)
            }
        }
        return cell
    }
    
    private func loadingIndicator() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }
    
    private func getMoviePublisherByClassification(_ classification: Int) -> Published<[Movie]?>.Publisher? {
        switch classification {
        case MovieClassification.Trending.rawValue:
            return $trendingMovies
        case MovieClassification.Popular.rawValue:
            return $popularMovies
        case MovieClassification.Upcoming.rawValue:
            return $upcomingMovies
        case MovieClassification.TopRated.rawValue:
            return $topratedMovies
        case MovieClassification.Discover.rawValue:
            return $discoverMovies
        default:
            return nil
        }
    }
    
    private func getTVPublisherByClassification(_ classification: Int) -> Published<[TV]?>.Publisher? {
        switch classification {
        case TVClassification.Trending.rawValue:
            return $trendingTvs
        default:
            return nil
        }
    }
    
    private func getTitlesByClassification(_ classification: Int) -> [Any]? {
        switch classification {
        case MovieClassification.Trending.rawValue:
            return trendingMovies
        case MovieClassification.Popular.rawValue:
            return popularMovies
        case MovieClassification.Upcoming.rawValue:
            return upcomingMovies
        case MovieClassification.TopRated.rawValue:
            return topratedMovies
        case TVClassification.Trending.rawValue:
            return trendingTvs
        case MovieClassification.Discover.rawValue:
            return discoverMovies
        default:
            return nil
        }
    }
    
    private func fetchTitlesByClassification(_ classification: Int) {
        switch classification {
        case MovieClassification.Trending.rawValue:
            self.fetchTrendingMovies()
            break
        case MovieClassification.Popular.rawValue:
            self.fetchPopularMovies()
            break
        case MovieClassification.Upcoming.rawValue:
            self.fetchUpcomingMovies()
            break
        case MovieClassification.TopRated.rawValue:
            self.fetchTopRatedMovies()
            break
        case TVClassification.Trending.rawValue:
            self.fetchTrendingTvs()
            break
        case MovieClassification.Discover.rawValue:
            self.fetchDiscoverMovies()
            break
        default:
            break
        }
    }
    
    func fetchTrendingMovies() {
        Task { @MainActor in
            do {
                self.trendingMovies = try await self.moviesService.fetchTrending()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func fetchPopularMovies() {
        Task { @MainActor in
            do {
                self.popularMovies = try await self.moviesService.fetchPopular()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func fetchUpcomingMovies() {
        Task { @MainActor in
            do {
                self.upcomingMovies = try await self.moviesService.fetchUpcoming()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func fetchTopRatedMovies() {
        Task { @MainActor in
            do {
                self.topratedMovies = try await self.moviesService.fetchTopRated()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func fetchTrendingTvs() {
        Task { @MainActor in
            do {
                self.trendingTvs = try await self.tvService.fetchTrending()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func fetchDiscoverMovies() {
        Task { @MainActor in
            do {
                self.discoverMovies = try await self.moviesService.fetchDiscover()
            } catch let error as Error {
                print(error.message)
            }
        }
    }
    
    func searchMovies(with query: String) {
        Task { @MainActor in
            do {
                self.searchedMovies = try await self.moviesService.fetchSearch(with: query)
            } catch let error as Error {
                print(error.message)
            }
        }
    }
}
