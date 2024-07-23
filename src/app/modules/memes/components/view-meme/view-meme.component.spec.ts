import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ViewMemeComponent } from './view-meme.component';

describe('ViewMemeComponent', () => {
  let component: ViewMemeComponent;
  let fixture: ComponentFixture<ViewMemeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ViewMemeComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ViewMemeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
