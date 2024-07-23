import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, catchError, of } from 'rxjs';
import { MemeResponse } from './interfaces/memes-response.interface';
import { Meme } from './interfaces/memes.interface';
import { MemeProvider } from './interfaces/memes-provider.interface';
import { LoaderService } from '../shared/loader.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root',
})
export class MemesService {
  public memeList: BehaviorSubject<Meme[]> = new BehaviorSubject<Meme[]>([]);
  public memesProvider: MemeProvider[] = [
    {
      provider: 'MemesEspanol',
      name: 'Memes en Español',
    },
    {
      provider: 'ProgrammerHumor',
      name: 'Programmer Humor',
    },
    {
      provider: 'DankMeme',
      name: 'Dank Memes',
    },
    {
      provider: 'Wholesome',
      name: 'Wholesome Memes',
    },
    {
      provider: 'Animemes',
      name: 'Animemes',
    },
    {
      provider: 'HistoryMemes',
      name: 'History Memes',
    },
    {
      provider: 'BeelcitosMemes',
      name: 'Beelcitos Memes',
    },
  ];

  public currentProvider: string = '';
  constructor(
    private httpClient: HttpClient,
    private readonly loaderService: LoaderService,
    private _snackBar: MatSnackBar
  ) {
    this.currentProvider = this.memesProvider[0].provider;
  }

  public getMemesProvider(): MemeProvider[] {
    return this.memesProvider;
  }

  public setMemesProvider(provider: string) {
    this.currentProvider = provider;
    this.getMemes();
  }

  public getMemes() {
    this.loaderService.showLoader();
    this.httpClient
      .get<MemeResponse>(
        `https://meme-api.com/gimme/${this.currentProvider}/50`
      )
      .pipe(
        catchError((error) => {
          this._snackBar.open('Error al cargar los memes', 'Cerrar', {
            duration: 3000,
          });
          this.loaderService.hideLoader();
          return [];
        })
      )
      .subscribe((response: MemeResponse) => {
        this.memeList.next(response.memes);
        this.loaderService.hideLoader();
      });
  }
}
