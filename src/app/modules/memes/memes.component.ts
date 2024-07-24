import { Component } from '@angular/core';
import { MemesService } from '../../services/memes.service';
import { Meme } from '../../services/interfaces/memes.interface';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatSelectModule } from '@angular/material/select';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MemeProvider } from '../../services/interfaces/memes-provider.interface';
import { MatDialog } from '@angular/material/dialog';
import { ViewMemeComponent } from './components/view-meme/view-meme.component';
import { MatCardModule } from '@angular/material/card';
import { MatGridListModule } from '@angular/material/grid-list';

@Component({
  selector: 'app-memes',
  standalone: true,
  imports: [
    MatFormFieldModule,
    MatSelectModule,
    FormsModule,
    ReactiveFormsModule,
    MatCardModule,
    MatGridListModule,
  ],
  templateUrl: './memes.component.html',
  styleUrl: './memes.component.css',
})
export class MemesComponent {
  public memeList: Meme[] = [];
  public memeProviders: MemeProvider[];

  public providers = new FormControl('');

  constructor(
    private readonly memesService: MemesService,
    public readonly dialog: MatDialog
  ) {
    this.memesService.getMemes();
    this.memesService.memeList.subscribe((memes: Meme[]) => {
      this.memeList = memes;
    });
    this.memeProviders = this.memesService.getMemesProvider();
  }

  public onSelectChange(event: any) {
    this.memesService.setMemesProvider(event.value);
  }
  public openMeme(url: string, title: string) {
    this.dialog.open(ViewMemeComponent, {
      data: {
        title: title,
        url: url,
      },
      height: 'calc(100% - 30px)',
      width: 'calc(100% - 30px)',
      maxWidth: '100%',
      maxHeight: '100%',
    });
  }
}
